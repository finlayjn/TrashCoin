//
//  ImageCell.swift
//  TrashCoin
//
//  Created by Finlay Nathan on 10/26/19.
//  Copyright © 2019 Finlay Nathan. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var trashImageView: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
