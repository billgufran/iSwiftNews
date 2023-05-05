//
//  TopNewsTableViewCell.swift
//  iSwiftNews
//
//  Created by Muhammad Fikri Bill Gufran on 5/5/23.
//

import UIKit

protocol TopNewsTableViewCellDelegate: AnyObject {
    func pageControlValueChanged(_ cell: TopNewsTableViewCell)
}

class TopNewsTableViewCell: UITableViewCell {
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: TopNewsTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func pageControlValueChanged(_ sender: Any) {
        delegate?.pageControlValueChanged(self)
    }
}
