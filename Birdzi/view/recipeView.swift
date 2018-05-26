//
//  recipeView.swift
//  Birdzi
//
//  Created by Dinesh Jagtap on 4/24/18.
//  Copyright © 2018 Birdzi. All rights reserved.
//

import UIKit
import FSPagerView
import SDWebImage
class recipeView: UIView, FSPagerViewDataSource, FSPagerViewDelegate{
    @IBOutlet weak var recipeBanner: FSPagerView! {
        didSet {
            self.recipeBanner.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.recipeBanner.itemSize = .zero
        }
    }
    var imageNames :NSMutableArray = GlobalVariablesArr.globalRecipeArr
    /*  required init(coder aDecoder: NSCoder) {
     super.init(coder: aDecoder)!
     Bundle.main.loadNibNamed("bannerView", owner: self, options: nil)
     self.addBanner.frame = bounds
     self.addSubview(self.addBanner)
     }*/
    
    // for this to work programmatically I had to do the same...
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("recipeView", owner: self, options: nil)
        self.recipeBanner.frame = bounds
        imageNames   = GlobalVariablesArr.globalRecipeArr
        recipeBanner.delegate = self;
        recipeBanner.dataSource = self;
//        recipeBanner.automaticSlidingInterval = 3
//        recipeBanner.alwaysBounceHorizontal = true
//        recipeBanner.isInfinite = true

        self.addSubview(self.recipeBanner)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //  fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.imageNames.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
    //    cell.title.text = (self.productArr[indexPath.row] as! NSDictionary).value(forKey: "description") as? String
             cell.imageView?.sd_setImage(with:   self.imageNames[index] as? URL , placeholderImage: UIImage(named: "loadding.jpg"))
        
        //    cell.imageView?.image = UIImage(named:)
        cell.imageView?.contentMode = .scaleToFill
        cell.imageView?.clipsToBounds = true
        //    cell.textLabel?.text = index.description+index.description
        return cell;
    }
}

