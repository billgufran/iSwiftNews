//
//  NewsTableViewCell.swift
//  iSwiftNews
//
//  Created by Muhammad Fikri Bill Gufran on 4/5/23.
//

import UIKit

protocol NewsTableViewCellDelegate: AnyObject {
    func cellBookmarkButtonTapped(_ cell: NewsTableViewCell)
}

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    weak var delegate: NewsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setup() {
        setThumbImageStyles()
    }
    
    func setThumbImageStyles() {
        if thumbImage != nil {
            thumbImage.layer.cornerRadius = 8
            thumbImage.layer.masksToBounds = true
        }
    }
    
    @IBAction func bookmarkButtonTapped(_ sender: Any) {
        delegate?.cellBookmarkButtonTapped(self)
    }
    
}
