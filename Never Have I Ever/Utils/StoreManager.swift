import UIKit
import ApphudSDK
import StoreKit
import Amplitude

struct StoreManager {

    struct Product {
        var id: String
        var price: String
        var subscriptionPeriod: String
        var trialPeriod: String?
        var apphudProduct: ApphudProduct
        var skProduct: SKProduct
    }

    public static func updateStatus(completion: (() -> ())? = nil) {
        State.shared.isSubscribed = Apphud.hasActiveSubscription()
        completion?() ?? ()
    }

    public static func getProducts(for productIds: [String], completion: @escaping (([Product]) -> ())) {

        var foundProducts: [StoreManager.Product] = []

        Apphud.paywallsDidLoadCallback { paywalls in

            // retrieve current paywall with identifier

            let paywall = paywalls.first(where: { $0.isDefault })
            var products: [ApphudProduct] = []

            // retrieve the products [ApphudProduct] from current paywall
            if let paywall = paywall {
                products = paywall.products
            }

            productIds.forEach { productId in

                for apphudProduct in products {

                    guard apphudProduct.productId == productId else { continue }

                    guard let skProduct = apphudProduct.skProduct else {
                        print("not found skProduct")
                        return
                    }

                    // Product price
                    let price = skProduct.localizedPrice ?? skProduct.price.stringValue

                    let subscriptionPeriod = skProduct.getSubscriptionPeriod()
                    let trialPeriod = skProduct.getTrialPeriod()

                    let customProduct = Product(id: skProduct.productIdentifier, price: price, subscriptionPeriod: subscriptionPeriod, trialPeriod: trialPeriod, apphudProduct: apphudProduct, skProduct: skProduct)

                    foundProducts.append(customProduct)
                }

            }

            completion(foundProducts)

        }

    }

    public static func purchase(_ product: Product, completion: (() -> ())? = nil) {

        topController().showLoader()
        
        Apphud.purchase(product.apphudProduct) { purchaseResult in

            topController().hideLoader()
            
            if let subscription = purchaseResult.subscription, subscription.isActive() {

                Amplitude.instance().logEvent("Subscription purchased",
                                              withEventProperties: [
                                                "Transaction identifier": purchaseResult.transaction?.transactionIdentifier ?? "",
                                                "Transaction date": purchaseResult.transaction?.transactionDate ?? Date(),
                                                "Transaction product identifier": purchaseResult.transaction?.payment.productIdentifier ?? ""
                                              ])

                print("Purchase Success: \(product.id)")
                State.shared.isSubscribed = true
                completion?() ?? ()
            }

        }

    }

    public static func restore(completion: (() -> ())? = nil) {

        topController().showLoader()
        
        self.updateStatus()

        guard !State.shared.isSubscribed else {
            topController().showAlreadySubscribedAlert()
            return
        }

        Apphud.restorePurchases{ subscriptions, purchases, error in

            topController().hideLoader {
                
                if Apphud.hasActiveSubscription() {
                    
                    State.shared.isSubscribed = true
                    topController().showRestoredAlert() {
                        completion?() ?? ()
                    }
                    
                } else {
                    
                    // no active subscription found, check non-renewing purchases or error
                    topController().showNotSubscriberAlert()
                    
                }
                
            }
        }

    }

}

/*
 //           _._
 //        .-'   `
 //      __|__
 //     /     \
 //     |()_()|
 //     \{o o}/
 //      =\o/=
 //       ^ ^
 */
