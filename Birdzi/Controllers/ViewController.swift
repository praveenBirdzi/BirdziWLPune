//
//  ViewController.swift
//  Birdzi
//
//  Created by Dinesh Jagtap on 4/12/18.
//  Copyright © 2018 Birdzi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var loadingimg: UIImageView!
    @IBOutlet weak var birdiLogo: UIImageView!
    @IBOutlet weak var storeLogo: UIImageView!
    @IBOutlet weak var bgBlure: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        bgBlure.blurImage(frame: .zero)

        if(UserDefaults.standard.bool(forKey: "isLoading"))
        {
            self.loadData()
        }
        else if(UserDefaults.standard.bool(forKey: "isLoyalty"))
        {
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Loyalty") as! Loyalty
            self.navigationController?.pushViewController(secondVC, animated: true)
        }
        else
        {
            if(UserDefaults.standard.bool(forKey: "hasLogin"))
            {
                let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! Home
                self.navigationController?.pushViewController(secondVC, animated: true)
            }
            else
            {
                let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
                self.navigationController?.pushViewController(secondVC, animated: true)
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadData()
    {
        let jeremyGif = UIImage.gifImageWithName("img_loader_animation")
        loadingimg.image = jeremyGif
        // let heights =  storeLogo.frame.size.height + 10;
        //  let widths =  storeLogo.frame.size.width + 10;
        
        //      let rect = CGRect(origin: CGPoint(x: loadingimg.frame.origin.x,y :loadingimg.frame.origin.y), size: CGSize(width: widths, height: heights ))
        //  self.loadingimg.frame = rect;
        let jeremyGifs = UIImage.gifImageWithName("img_birdzi_animation")
        birdiLogo.image = jeremyGifs
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.8) {
            // your code here For Pushing to Another Screen
            if(UserDefaults.standard.bool(forKey: "hasLogin"))
            {
                let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! Home
                self.navigationController?.pushViewController(secondVC, animated: true)
            }
            else
            {
                if(UserDefaults.standard.bool(forKey: "isLoyalty"))
                {
                    let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Loyalty") as! Loyalty
                    self.navigationController?.pushViewController(secondVC, animated: true)
                }
                else
                {
                let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
                self.navigationController?.pushViewController(secondVC, animated: true)
                }
                
            }
        }
    }


}
extension AppDelegate {
    func findCurrentViewController() -> UIViewController{
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        
        return findCurrentViewController(byTempTopVC: rootVC!)
    }
    
    func findCurrentViewController(byTempTopVC vc: UIViewController) -> UIViewController {
        let presentedVC = vc.presentedViewController
        
        guard presentedVC != nil else {
            return vc
        }
        if (presentedVC?.isKind(of: UINavigationController.self))!{
     //   if presentedVC.isKindOfClass(UINavigationController) {
            let theNav =  presentedVC
            let theTopVC = theNav!.childViewControllers.last
            return findCurrentViewController(byTempTopVC: theTopVC!)
        }
        
        return findCurrentViewController(byTempTopVC: presentedVC!)
    }
}
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

private var bottomLineColorAssociatedKey : UIColor = .black
private var topLineColorAssociatedKey : UIColor = .black
private var rightLineColorAssociatedKey : UIColor = .black
private var leftLineColorAssociatedKey : UIColor = .black
extension UIView {
    @IBInspectable var bottomLineColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &bottomLineColorAssociatedKey) as? UIColor {
                return color
            } else {
                return .black
            }
        } set {
            objc_setAssociatedObject(self, &bottomLineColorAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    @IBInspectable var bottomLineWidth: CGFloat {
        get {
            return self.bottomLineWidth
        }
        set {
            DispatchQueue.main.async {
                self.addBottomBorderWithColor(color: self.bottomLineColor, width: newValue)
            }
        }
    }
    @IBInspectable var topLineColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &topLineColorAssociatedKey) as? UIColor {
                return color
            } else {
                return .black
            }
        } set {
            objc_setAssociatedObject(self, &topLineColorAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    @IBInspectable var topLineWidth: CGFloat {
        get {
            return self.topLineWidth
        }
        set {
            DispatchQueue.main.async {
                self.addTopBorderWithColor(color: self.topLineColor, width: newValue)
            }
        }
    }
    @IBInspectable var rightLineColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &rightLineColorAssociatedKey) as? UIColor {
                return color
            } else {
                return .black
            }
        } set {
            objc_setAssociatedObject(self, &rightLineColorAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    @IBInspectable var rightLineWidth: CGFloat {
        get {
            return self.rightLineWidth
        }
        set {
            DispatchQueue.main.async {
                self.addRightBorderWithColor(color: self.rightLineColor, width: newValue)
            }
        }
    }
    @IBInspectable var leftLineColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &leftLineColorAssociatedKey) as? UIColor {
                return color
            } else {
                return .black
            }
        } set {
            objc_setAssociatedObject(self, &leftLineColorAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    @IBInspectable var leftLineWidth: CGFloat {
        get {
            return self.leftLineWidth
        }
        set {
            DispatchQueue.main.async {
                self.addLeftBorderWithColor(color: self.leftLineColor, width: newValue)
            }
        }
    }
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "topBorderLayer"
        removePreviouslyAddedLayer(name: border.name ?? "")
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y : 0,width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "rightBorderLayer"
        removePreviouslyAddedLayer(name: border.name ?? "")
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width : width, height :self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "bottomBorderLayer"
        removePreviouslyAddedLayer(name: border.name ?? "")
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,width : self.frame.size.width,height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "leftBorderLayer"
        removePreviouslyAddedLayer(name: border.name ?? "")
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0,width : width, height : self.frame.size.height)
        self.layer.addSublayer(border)
    }
    func removePreviouslyAddedLayer(name : String) {
        if self.layer.sublayers?.count ?? 0 > 0 {
            self.layer.sublayers?.forEach {
                if $0.name == name {
                    $0.removeFromSuperlayer()
                }
            }
        }
    }
}
