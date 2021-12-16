import Foundation

struct SubscriptionConfig: Codable {
    
    let lang: Language.Code
    let title: String
    let trialPeriodTitle: String
    let buttonTitle: String
    let firstProduct: Product
    let secondProduct: Product
    let reasons: [String]
    let showCloseButton: Bool
    let freeTasksCount: Int
    
    internal struct Product: Codable {
        let title: String
        let subtitle: String
        let productId: String
        let saveLabel: String?
    }
    
    public static let `default` = SubscriptionConfig(
        lang: .en,
        title: "Spice up your night!",
        trialPeriodTitle: "%trial_period% FREE",
        buttonTitle: "START FREE TRIAL",
        firstProduct: Product(
            title: "Трехмесячная",
            subtitle: "%trial_perion% free",
            productId: "3m3d2",
            saveLabel: "SAVE 68$"
        ),
        secondProduct: Product(
            title: "Недельная",
            subtitle: "%trial_perion% free",
            productId: "com.haverhavei.week",
            saveLabel: nil
        ),
        reasons: [
            "Have even more fun",
            "Truly candid levels await you",
            "The coolest updates"
        ],
        showCloseButton: true,
        freeTasksCount: 1
    )
    
    public static func get(completion: (() -> ())? = nil) {
        
        
        loadFromUrl { error in
            
            if let error = error {
                
                print("-------------------------")
                print("Error from url decoding of subscription config:")
                print(error)
                print(error.localizedDescription)
                print("-------------------------")
                
                loadFromJson {
                    completion?() ?? ()
                }
                
                return
            }
            
            completion?() ?? ()
            
        }
        
    }
    
    private static func loadFromJson(completion: (() -> ())) {
        
        let jsonData = readLocalJSONFile(forName: "subscriptionPage")!
        do {
            let configs = try JSONDecoder().decode([SubscriptionConfig].self, from: jsonData)
            
            configs.forEach { config in
                if config.lang == State.shared.getLanguageCode() {
                    State.shared.subscriptionConfig = config
                    completion()
                    print("Subsctiption config loaded from json file")
                }
            }
            
        } catch {
            print("-------------------------")
            print("Error from json decoding of subscription config:")
            print(error)
            print(error.localizedDescription)
            print("-------------------------")
        }
    }
    
    private static func loadFromUrl(completion: @escaping (Error?) -> ()) {
        
        let urlString = Config.SUBSCRIPTION_CONFIG_URL
        guard let url = URL(string: urlString) else { fatalError() }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(error)
                return
            }

            do {
                let configs = try JSONDecoder().decode([SubscriptionConfig].self, from: data)
                
                configs.forEach { config in
                    if config.lang == State.shared.getLanguageCode() {
                        State.shared.subscriptionConfig = config
                        completion(nil)
                        print("Subsctiption config loaded from url")
                    }
                }
                
            } catch {
                completion(error)
            }

        }.resume()
        
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
