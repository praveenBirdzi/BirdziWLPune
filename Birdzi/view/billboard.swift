//
//  billboard.swift
//  Birdzi
//
//  Created by Dinesh Jagtap on 4/25/18.
//  Copyright © 2018 Birdzi. All rights reserved.
//

import UIKit
import FSPagerView
import SDWebImage

class billboard: UIView, FSPagerViewDataSource, FSPagerViewDelegate{
    weak var controller:Home!
    var isScroll : Bool = false

    @IBOutlet weak var billboardView: FSPagerView! {
        didSet {
            self.billboardView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.billboardView.itemSize = .zero
        }
    }
    var imageNames :NSMutableArray = GlobalVariablesArr.globalBillboardArr
    /*  required init(coder aDecoder: NSCoder) {
     super.init(coder: aDecoder)!
     Bundle.main.loadNibNamed("bannerView", owner: self, options: nil)
     self.addBanner.frame = bounds
     self.addSubview(self.addBanner)
     }*/
    
    // for this to work programmatically I had to do the same...
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("billboard", owner: self, options: nil)
        self.billboardView.frame = bounds
        imageNames   = GlobalVariablesArr.globalBillboardArr
        billboardView.delegate = self;
        billboardView.dataSource = self;
        self.isScroll = GlobalVariables.globalISScolling
        if(GlobalVariables.globalISScolling){
        billboardView.automaticSlidingInterval = 6
        billboardView.alwaysBounceHorizontal = true
            billboardView.isInfinite = true

        }
        else
        {
            billboardView.alwaysBounceHorizontal = false
            billboardView.isInfinite = false

        }
        
        self.addSubview(self.billboardView)
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
    //    print(self.imageNames[index] as? URL)
        //    cell.title.text = (self.productArr[indexPath.row] as! NSDictionary).value(forKey: "description") as? String
        let myWebView:UIWebView = UIWebView(frame: self.billboardView.frame)
        
        let myURLRequest:URLRequest = URLRequest(url: (self.imageNames[index] as? URL)!)
        myWebView.loadRequest(myURLRequest)
        if(self.isScroll){
        myWebView.isOpaque = false;
        }
        myWebView.backgroundColor = UIColor.clear
       // myWebView.delegate = self
        myWebView.scalesPageToFit = true
        myWebView.allowsInlineMediaPlayback = true
        myWebView.scrollView.isScrollEnabled = false;

       // myWebView.
        cell.addSubview(myWebView)
        
      //  cell.imageView?.sd_setImage(with:self.imageNames[index] as? URL , placeholderImage: UIImage(named: "loadding.jpg"))
             //    cell.imageView?.image = UIImage(named:)
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.clipsToBounds = true
        //    cell.textLabel?.text = index.description+index.description
        return cell;
    }
  
//    func webView(_ webView: UIWebView,shouldStartLoadWith request: URLRequest,navigationType: UIWebViewNavigationType) -> Bool{
//
////         if navigationType == UIWebViewNavigationType.linkClicked {
////     //       let str = try String(contentsOf: shouldStartLoadWith.url!)
////            print(request.url?.absoluteString)
////            let fullNameArr = request.url?.absoluteString.components(separatedBy: ":")
////            print(fullNameArr)
////            let app_name    = fullNameArr![0]
////            let action_name = fullNameArr![1]
////            let action_base_url =  fullNameArr![3]
////            let action_url =  fullNameArr![4]
////
////            if(app_name == "birdziapp")
////            {
////                if(action_name == "playvideo")
////                {
////                    let urlStr = String(format:"%@:%@",action_base_url,action_url)
////                    let videoURL = NSURL(string: urlStr)
////
//////                    if let url =  NSURL(string: urlStr){
//////                        UIApplication.shared.openURL(url as URL)
//////                    }
////                    let currentController = UIApplication.topViewController()
////
////                    let video = AVPlayer(url: videoURL as! URL)
////                    let videoPlayer = AVPlayerViewController()
////                    videoPlayer.player = video
////                    currentController?.present(videoPlayer, animated: true, completion:
////                        {
////                            video.play()
////                    })
////
////                }
////                if(action_name == "launchurl")
////                {
////                    let urlStr = String(format:"%@:%@",action_base_url,action_url)
////                    let videoURL = NSURL(string: urlStr)
////
////                    if let url =  NSURL(string: urlStr){
////                        UIApplication.shared.openURL(url as URL)
////                    }
////
////                }
////                if(action_name == "product_detail")
////                {
////                    let urlStr = String(format:"%@:%@",action_base_url,action_url)
////                    let videoURL = NSURL(string: urlStr)
////
////                    let currentController = UIApplication.topViewController()
////
////
//////                    currentController?.navigationController!.view.layer.add(transition, forKey: kCATransition)
//////                    currentController?.present(productDetailVC(), animated: false, completion: nil)
////
////                }
////            }
////
////
////          //UIApplication.shared.open(shouldStartLoadWith.url!, options: [:], completionHandler: nil)
////            return false
////        }
//        return true
//    }
//    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
//        let myURLString =  self.imageNames[index] as? URL
//        if let url = myURLString {
//            do {
//                let contents = try String(contentsOf: url)
//                print(contents)
//
//            } catch {
//                // contents could not be loaded
//            }
//        } else {
//            // the URL was bad!
//        }
//    }

}

