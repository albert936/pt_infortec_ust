//
//  CharacterCell.swift
//  Marvel
//
//  Created by Albert on 15/11/20.
//

import UIKit

class CharacterCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.textColor = UIColor.white.withAlphaComponent(0.66)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        nameLabel.text = ""
    }    
}
