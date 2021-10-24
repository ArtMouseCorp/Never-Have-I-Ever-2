import Foundation
import StoreKit

extension SKProduct {
    
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    var isFree: Bool {
        price == 0.00
    }
    
    var localizedPrice: String? {
        guard !isFree else {
            return nil
        }
        
        let formatter = SKProduct.formatter
        formatter.locale = priceLocale
        
        return formatter.string(from: price)
    }
    
    func getSubscriptionPeriod(showOne: Bool = false) -> String {

        let perdiod = self.subscriptionPeriod
        let numberOfUnits = perdiod?.numberOfUnits ?? 0

        var unit = ""

        switch perdiod!.unit {

        case .day:
            let oneDay = localized("subscription.intervar.day.one")
            let twoDays = localized("subscription.intervar.day.two")
            let fiveDays = localized("subscription.intervar.day.five")

            unit = getNoun(number: numberOfUnits, one: oneDay, two: twoDays, five: fiveDays)
        case .week:
            let oneWeek = localized("subscription.intervar.week.one")
            let twoWeeks = localized("subscription.intervar.week.two")
            let fiveWeeks = localized("subscription.intervar.week.five")

            unit = getNoun(number: numberOfUnits, one: oneWeek, two: twoWeeks, five: fiveWeeks)
        case .month:
            let oneMonth = localized("subscription.intervar.month.one")
            let twoMonths = localized("subscription.intervar.month.two")
            let fiveMonths = localized("subscription.intervar.month.five")

            unit = getNoun(number: numberOfUnits, one: oneMonth, two: twoMonths, five: fiveMonths)
        case .year:
            let oneYear = localized("subscription.intervar.year.one")
            let twoYears = localized("subscription.intervar.year.two")
            let fiveYears = localized("subscription.intervar.year.five")

            unit = getNoun(number: numberOfUnits, one: oneYear, two: twoYears, five: fiveYears)
        @unknown default:
            unit = "N/A"
        }

        if showOne {
            return "\(numberOfUnits) \(unit)"
        } else {
            return numberOfUnits > 1 ? "\(numberOfUnits) \(unit)" : unit
        }
    }

    func getTrialPeriod() -> String? {

        let perdiod = self.introductoryPrice?.subscriptionPeriod
        let numberOfUnits = perdiod?.numberOfUnits ?? 0

        var unit = ""

        switch perdiod?.unit {

        case .day:
            let oneDay = localized("subscription.intervar.day.one")
            let twoDays = localized("subscription.intervar.day.two")
            let fiveDays = localized("subscription.intervar.day.five")

            unit = getNoun(number: numberOfUnits, one: oneDay, two: twoDays, five: fiveDays)
        case .week:
            let oneWeek = localized("subscription.intervar.week.one")
            let twoWeeks = localized("subscription.intervar.week.two")
            let fiveWeeks = localized("subscription.intervar.week.five")

            unit = getNoun(number: numberOfUnits, one: oneWeek, two: twoWeeks, five: fiveWeeks)
        case .month:
            let oneMonth = localized("subscription.intervar.month.one")
            let twoMonths = localized("subscription.intervar.month.two")
            let fiveMonths = localized("subscription.intervar.month.five")

            unit = getNoun(number: numberOfUnits, one: oneMonth, two: twoMonths, five: fiveMonths)
        case .year:
            let oneYear = localized("subscription.intervar.year.one")
            let twoYears = localized("subscription.intervar.year.two")
            let fiveYears = localized("subscription.intervar.year.five")

            unit = getNoun(number: numberOfUnits, one: oneYear, two: twoYears, five: fiveYears)
        case .none:
            return nil
        @unknown default:
            unit = "N/A"
        }

        return "\(numberOfUnits) \(unit)"
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
