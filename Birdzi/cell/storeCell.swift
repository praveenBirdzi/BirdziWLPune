//
//  storeCell.swift
//  Birdzi
//
//  Created by Dinesh Jagtap on 5/24/18.
//  Copyright © 2018 Birdzi. All rights reserved.
//

import UIKit

class storeCell: UITableViewCell {
    @IBOutlet weak var store_address: UILabel!
    @IBOutlet weak var store_distance: UILabel!
     @IBOutlet weak var submitButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
