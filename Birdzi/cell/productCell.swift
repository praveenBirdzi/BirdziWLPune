//
//  productCell.swift
//  Birdzi
//
//  Created by Dinesh Jagtap on 4/24/18.
//  Copyright © 2018 Birdzi. All rights reserved.
//

import UIKit

class productCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cartButton: UIButton!

  //  @IBOutlet weak var addCartBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
