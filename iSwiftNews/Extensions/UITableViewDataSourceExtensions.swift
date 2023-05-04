//
//  UITableViewDataSourceExtensions.swift
//  iSwiftNews
//
//  Created by Muhammad Fikri Bill Gufran on 4/5/23.
//

import UIKit

extension UITableViewDataSource {
    func concatLabels(_ labels: [String], delimiter: String = " • ") -> String {
        labels.joined(separator: delimiter)
    }
}
