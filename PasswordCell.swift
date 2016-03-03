//
//  PasswordCell.swift
//  Password
//
//  Created by Sword on 2/4/16.
//  Copyright © 2016 Sword. All rights reserved.
//

import UIKit

class PasswordCell: UITableViewCell {

    var passwordItem:PasswordItem? {
        didSet {
            self.setNeedsLayout()
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()        
        nameLabel.text = passwordItem?.name
    }

}
