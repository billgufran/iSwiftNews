//
//  UIImageViewExtensions.swift
//  iSwiftNews
//
//  Created by Muhammad Fikri Bill Gufran on 5/5/23.
//

import UIKit

extension UIImageView {
    func rounded(_ radius: CGFloat = 8) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}

