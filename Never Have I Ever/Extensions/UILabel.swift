import UIKit

extension UILabel {
    
    public func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
            self.attributedText = attributeString
        }
    }
    
    public func contentHeight(lineSpacing: CGFloat) -> CGFloat {
        self.setLineHeight(lineHeight: lineSpacing)
        self.sizeToFit()
        return self.frame.height
    }
    
    public func localize(with key: String) {
        self.text = localized(key)
    }
 
    public func colorText(from: String, to: String, color: UIColor) {
        
        guard var text = self.text else { return }
        
        guard let toColor = text.slice(from: from, to: to) else {
            self.text = text
                .replacingOccurrences(of: from, with: "")
                .replacingOccurrences(of: to, with: "")
            return
        }
        
        text = text
            .replacingOccurrences(of: from, with: "")
            .replacingOccurrences(of: to, with: "")
        
        let attributedText = NSMutableAttributedString(string: text)
        
        let range = NSRange(text.range(of: toColor)!, in: text)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color
        ]
        
        attributedText.setAttributes(attributes, range: range)

        self.attributedText = attributedText
        
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
