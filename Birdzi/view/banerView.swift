//
//  banerView.swift
//  Birdzi
//
//  Created by Dinesh Jagtap on 4/23/18.
//  Copyright © 2018 Birdzi. All rights reserved.
//

import UIKit
import FSPagerView
class banerView: UIView, FSPagerViewDataSource, FSPagerViewDelegate  {
    
    @IBOutlet weak var addBanner: FSPagerView!
    var imageNames :NSMutableArray = GlobalVariablesArr.globalBannerArr
    var view:UIView!
    
    
    
    
    
    override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
    }
    
    required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    self.imageNames = GlobalVariablesArr.globalBannerArr
    setup()
    }
    
    func setup() {
    view = loadViewFromNib()
    view.frame = bounds
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    addSubview(view)
    //    view.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
    }
    /*  func loadViewFromNib() -> UIView {
     let myView = Bundle.main.loadNibNamed("bannerView", owner: self, options: nil)?.first as! UIView
     return myView
     }*/
    func loadViewFromNib() -> UIView {
    //let views = Bundle.main.loadNibNamed("", owner: self, options: [AnyHashable : Any]?)
    //    let myView = Bundle.main.loadNibNamed("bannerView", owner: self, options: nil)?.first as! UIView
    //    return myView
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: "bannerView", bundle: bundle)
    let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    return view
    }
    func numberOfItems(in pagerView: FSPagerView) -> Int {
    return self.imageNames.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
    let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
    DispatchQueue.global().async {
    let data = try? Data(contentsOf:  self.imageNames[index] as! URL) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
    DispatchQueue.main.async {
    cell.imageView?.image = UIImage(data: data!)
    
    
    }
    }
    
    //    cell.imageView?.image = UIImage(named:)
    cell.imageView?.contentMode = .scaleAspectFill
    cell.imageView?.clipsToBounds = true
    //    cell.textLabel?.text = index.description+index.description
    return cell
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


