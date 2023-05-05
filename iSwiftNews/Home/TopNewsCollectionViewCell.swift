//
//  TopNewsCollectionViewCell.swift
//  iSwiftNews
//
//  Created by Muhammad Fikri Bill Gufran on 5/5/23.
//

import UIKit

class TopNewsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        setThumbImageStyles()
    }
    
    func setThumbImageStyles() {
        thumbImage.rounded()
    }    
}
