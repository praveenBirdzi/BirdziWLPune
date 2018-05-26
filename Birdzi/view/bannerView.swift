//
//  bannerView.swift
//  Birdzi
//
//  Created by Dinesh Jagtap on 4/23/18.
//  Copyright © 2018 Birdzi. All rights reserved.
//

import UIKit
import FSPagerView
import SDWebImage

@IBDesignable class bannerView: UIView, FSPagerViewDataSource, FSPagerViewDelegate{
    @IBOutlet weak var addBanner: FSPagerView! {
        didSet {
            self.addBanner.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.addBanner.itemSize = .zero
        }
    }
    // once with a NSCoder
     var imageNames :NSMutableArray = GlobalVariablesArr.globalBannerArr
    var actonURL :NSMutableArray = GlobalVariablesArr.globalActionArr

  /*  required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        Bundle.main.loadNibNamed("bannerView", owner: self, options: nil)
        self.addBanner.frame = bounds
        self.addSubview(self.addBanner)
    }*/
    
    // for this to work programmatically I had to do the same...
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("bannerView", owner: self, options: nil)
        self.addBanner.frame = bounds
           imageNames   = GlobalVariablesArr.globalBannerArr
        actonURL = GlobalVariablesArr.globalActionArr
        addBanner.delegate = self;
        addBanner.dataSource = self;
       // SDImageCache.config.shouldCacheImagesInMemory = NO
         self.addSubview(self.addBanner)
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
            
            cell.imageView?.sd_setImage(with:   self.imageNames[index] as? URL , placeholderImage: UIImage(named: "loadding.jpg"))

//            DispatchQueue.global().async {
//                let data = try? Data(contentsOf:  self.imageNames[index] as! URL) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//                DispatchQueue.main.async {
//                    cell.imageView?.image = UIImage(data: data!)
//
//
//                }
//            }
    
            //    cell.imageView?.image = UIImage(named:)
            cell.imageView?.contentMode = .scaleAspectFit
            cell.imageView?.clipsToBounds = true
            //    cell.textLabel?.text = index.description+index.description
            return cell;
        }
    
        func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
         //   let myURLString =  self.actonURL[index] as? URL
            if let url = self.actonURL[index] as? URL{
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url as URL)
                }
                                  }
        }

    
}
 //, FSPagerViewDataSource, FSPagerViewDelegate  {
//
//    @IBOutlet weak var addBanner: FSPagerView!
//    var imageNames :NSMutableArray = GlobalVariablesArr.globalBannerArr
//    var view:UIView!
//
//
//
//
//
// override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)!
//        self.imageNames = GlobalVariablesArr.globalBannerArr
//        setup()
//    }
//
//    func setup() {
//        view = loadViewFromNib()
//        view.frame = bounds
//        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        addSubview(view)
//    //    view.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
//    }
//   /*  func loadViewFromNib() -> UIView {
//        let myView = Bundle.main.loadNibNamed("bannerView", owner: self, options: nil)?.first as! UIView
//        return myView
//    }*/
//   func loadViewFromNib() -> UIView {
//    //let views = Bundle.main.loadNibNamed("", owner: self, options: [AnyHashable : Any]?)
////    let myView = Bundle.main.loadNibNamed("bannerView", owner: self, options: nil)?.first as! UIView
////    return myView
//        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: "bannerView", bundle: bundle)
//        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
//        return view
//    }
//    func numberOfItems(in pagerView: FSPagerView) -> Int {
//        return self.imageNames.count
//    }
//
//    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
//        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
//        DispatchQueue.global().async {
//            let data = try? Data(contentsOf:  self.imageNames[index] as! URL) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//            DispatchQueue.main.async {
//                cell.imageView?.image = UIImage(data: data!)
//
//
//            }
//        }
//
//        //    cell.imageView?.image = UIImage(named:)
//        cell.imageView?.contentMode = .scaleAspectFill
//        cell.imageView?.clipsToBounds = true
//        //    cell.textLabel?.text = index.description+index.description
//        return cell
//    }
//    /*
//    // Only override draw() if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//    }
//    */
//
//}
