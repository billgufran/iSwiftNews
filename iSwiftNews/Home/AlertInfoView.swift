//
//  AlertInfoView.swift
//  iSwiftNews
//
//  Created by Muhammad Fikri Bill Gufran on 5/5/23.
//

import UIKit

class AlertInfoView: UIView {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        setup()
    }
    
    func setup() {
        setContainerStyles()
        setTextStyles()
    }
    
    func setContainerStyles() {
        var borderColor = UIColor.lightGray.cgColor
        
        if #available(iOS 13.0, *) {
            borderColor = UIColor.separator.cgColor
        }
        
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        self.layer.borderColor = borderColor
    }
    
    func setTextStyles() {
        var titleColor = UIColor.systemBlue
        var descriptionColor = UIColor.systemGray
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2.5
        
        if #available(iOS 15.0, *) {
            titleColor = UIColor.tintColor
        }
        if #available(iOS 13.0, *) {
            descriptionColor = UIColor.secondaryLabel
        }
        
        let title = NSMutableAttributedString(
            string: "Covid-19 News: ",
            attributes: [
                .foregroundColor: titleColor,
                .font: UIFont.systemFont(
                    ofSize: 14, weight: .semibold
                ),
                .paragraphStyle: paragraphStyle,
            ]
        )
        let description = NSMutableAttributedString(
            string: "See the latest coverage about Covid-19",
            attributes: [
                .foregroundColor: descriptionColor,
                .font: UIFont.systemFont(ofSize: 14),
            ]
        )
        
        title.append(description)
        
        label.attributedText = title
    }
}
