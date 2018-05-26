//
//  storeInfo.swift
//  Birdzi
//
//  Created by Dinesh Jagtap on 4/25/18.
//  Copyright © 2018 Birdzi. All rights reserved.
//

import UIKit

class storeInfo: UIView {
    @IBOutlet weak var bgimgView: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var Address: UILabel!
    @IBOutlet weak var hrOpration: UILabel!
    @IBOutlet weak var times: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("storeInfo", owner: self, options: nil)
        self.Address.text = GlobalVariables.globalStoreAddress
        self.times.text = GlobalVariables.globalTimes
        self.hrOpration.text = GlobalVariables.globalOprationHr
        self.storeName.text = GlobalVariables.globalStoreName
        let thumb =  GlobalVariables.globalStoreImg
        let url = URL(string: thumb)
        self.imgView?.sd_setImage(with:  url , placeholderImage: UIImage(named: "loadding.jpg"))
        self.addSubview(self.bgimgView)
        self.addSubview(self.imgView)
        self.addSubview(self.times)
        self.addSubview(self.storeName)
        self.addSubview(self.Address)
        self.addSubview(self.hrOpration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //  fatalError("init(coder:) has not been implemented")
    }

}
