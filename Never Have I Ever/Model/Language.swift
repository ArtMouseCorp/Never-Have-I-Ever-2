import UIKit

struct Language {
    
    let name: String
    let image: UIImage
    let code: Code
    
    internal enum Code: String, Codable {
        case ru, en, de, fr, it, es, zh, sv, nl, fi
        
        init(_ value: String) {
            switch value {
            case "ru": self = .ru
            case "en": self = .en
            case "de": self = .de
            case "fr": self = .fr
            case "it": self = .it
            case "es": self = .es
            case "zh": self = .zh
            case "sv": self = .sv
            case "nl": self = .nl
            case "fi": self = .fi
            default: self = .en
            }
        }
        
        public func getLanguage() -> Language {
            return (Language.languages.first { $0.code == self })!
        }
    }
    
    static let languages: [Language] = [
        Language(name: "English",   image: .Flags.uk,           code: .en),
        Language(name: "Russian",   image: .Flags.russia,       code: .ru),
        Language(name: "German",    image: .Flags.germany,      code: .de),
        Language(name: "French",    image: .Flags.france,       code: .fr),
        Language(name: "Italian",   image: .Flags.italy,        code: .it),
        Language(name: "Spanish",   image: .Flags.spain,        code: .es),
//        Language(name: "Chinese",   image: .Flags.china,        code: .zh),
//        Language(name: "Swedish",   image: .Flags.sweden,       code: .sv),
//        Language(name: "Dutch",     image: .Flags.netherlands,  code: .nl),
//        Language(name: "Finnish",   image: .Flags.finland,      code: .fi),
        
    ]
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
