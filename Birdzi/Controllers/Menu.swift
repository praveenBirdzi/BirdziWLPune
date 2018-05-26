//
//  Menu.swift
//  Birdzi
//
//  Created by Dinesh Jagtap on 5/18/18.
//  Copyright © 2018 Birdzi. All rights reserved.
//

import UIKit
import JTMaterialTransition

class Menu: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var userBarcode: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var menuList :NSMutableArray = []
    var menuImgList :NSMutableArray = []
   // var transition: JTMaterialTransition?
    var animatedImage: UIImageView!
    var logo_img:UIImage = #imageLiteral(resourceName: "ic_dorothy_home_logo.png")
    @IBOutlet weak var bgBlure: UIImageView!
    @IBOutlet weak var logoImg: UIImageView!
    var transition: JTMaterialTransition?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuList = ["home","inbox","recipes","my list","offers","flyer","pairings","rewards","my faves","settings","help"]
        self.menuImgList = [#imageLiteral(resourceName: "ic_dorothy_home_logo.png"),#imageLiteral(resourceName: "ic_dorothy_inbox_logo.png"),#imageLiteral(resourceName: "ic_dorothy_recipes_logo.png"),#imageLiteral(resourceName: "ic_dorothy_my_list_logo.png"),#imageLiteral(resourceName: "ic_dorothy_offers_logo.png"),#imageLiteral(resourceName: "ic_dorothy_flyer_logo.png"),#imageLiteral(resourceName: "ic_dorothy_pairing_logo.png"),#imageLiteral(resourceName: "ic_dorothy_rewards_logo.png"),#imageLiteral(resourceName: "ic_dorothy_my_faves_logo.png"),#imageLiteral(resourceName: "ic_dorothy_settings_logo.png"),#imageLiteral(resourceName: "ic_dorothy_help_logo.png")]
        searchTxt.layer.masksToBounds = false
        searchTxt.layer.shadowColor = UIColor.lightGray.cgColor
        searchTxt.layer.shadowOpacity = 0.5
        searchTxt.layer.shadowRadius = 4.0
        searchTxt.layer.shadowOffset = CGSize(width:0.0,  height:1.0)
        bgBlure.blurImageMenu(frame: self.logoImg.frame)
        self.logoImg.image = logo_img
        self.transition = JTMaterialTransition(animatedView: self.menuBtn)
        self.transition?.transitionDuration = 0.6
        // Do any additional setup after loading the view.
    }
    @IBAction func menuBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBOutlet weak var barcodeScan: UIButton!
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 1
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 2
        return menuList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                      for: indexPath) as! menuCell
        cell.menuLbl.text = self.menuList.object(at: indexPath.row) as? String
        cell.imgView.image = self.menuImgList.object(at: indexPath.row) as? UIImage
 
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 
        let cell:menuCell = collectionView.cellForItem(at: indexPath) as! menuCell
        
        animatedImage = UIImageView(frame: cell.imgView.frame)
        
 
        let rect = CGRect(origin: CGPoint(x: cell.frame.origin.x + self.collectionView.frame.origin.x + cell.imgView.frame.origin.x ,y :cell.frame.origin.y + self.collectionView.frame.origin.y + self.menuView.frame.origin.y + cell.imgView.frame.origin.y), size: CGSize(width: cell.imgView.frame.size.width, height: cell.imgView.frame.size.height))
        
        animatedImage.frame = rect
        animatedImage.image = self.menuImgList.object(at: indexPath.row) as? UIImage
        
     //   self.logoImg.image = self.animatedImage.image

        UIView.animate(withDuration: 0.6
            , animations: {
                 self.view.addSubview(self.animatedImage)
                cell.imgView.isHidden = true
                self.animatedImage.frame = self.menuBtn.frame

        }, completion: { value in
            ///// self.logoImg.
          //  self.logoImg.removeFromSuperview()
           // self.logoImg = self.animatedImage
           // self.animatedImage.image = nil;
            
            if(cell.menuLbl.text == "home")
            {
                self.dismiss(animated: true, completion: {
                    let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! Home
                    secondVC.modalPresentationStyle = .custom
                    secondVC.transitioningDelegate = self.transition
                    let currentController = UIApplication.topViewController()
                    
                    currentController?.navigationController?.pushViewController(secondVC, animated: false)
                })
            }
           else if(cell.menuLbl.text == "my list")
            {
 
                self.dismiss(animated: true, completion: {
                      let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "ShoppingList") as! ShoppingList
                     secondVC.modalPresentationStyle = .custom
                      secondVC.transitioningDelegate = self.transition
                      let currentController = UIApplication.topViewController()
 
                    currentController?.navigationController?.pushViewController(secondVC, animated: false)
                 })
 

            }
            else
            {
            }
         //   self.dismiss(animated: true, completion: nil)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
