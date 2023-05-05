//
//  UILabelExtensions.swift
//  iSwiftNews
//
//  Created by Muhammad Fikri Bill Gufran on 5/5/23.
//

import UIKit

extension UILabel {
    func concatLabelsToText(_ labels: [String], delimiter: String = " • ") {
        self.text = labels.joined(separator: delimiter)
    }
}

