//
//  ShoppingList.swift
//  Birdzi
//
//  Created by Dinesh Jagtap on 5/18/18.
//  Copyright © 2018 Birdzi. All rights reserved.
//

import UIKit
import JTMaterialTransition

class ShoppingList: UIViewController {
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var menuBtn: UIButton!
    var transition: JTMaterialTransition?
    @IBOutlet weak var userBarcode: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var menuList :NSMutableArray = []
    var menuImgList :NSMutableArray = []
    // var transition: JTMaterialTransition?
    var animatedImage: UIImageView!
    @IBOutlet weak var bgBlure: UIImageView!
    @IBOutlet weak var logoImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTxt.layer.masksToBounds = false
        searchTxt.layer.shadowColor = UIColor.lightGray.cgColor
        searchTxt.layer.shadowOpacity = 0.5
        searchTxt.layer.shadowRadius = 4.0
        searchTxt.layer.shadowOffset = CGSize(width:0.0,  height:1.0)
        bgBlure.blurImage(frame: self.logoImg.frame)
        self.transition = JTMaterialTransition(animatedView: self.menuBtn)
        self.transition?.transitionDuration = 0.6
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func menuBtn(_ sender: UIButton) {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Menu") as! Menu
        secondVC.logo_img = #imageLiteral(resourceName: "ic_dorothy_my_list_logo.png")
        secondVC.modalPresentationStyle = .overCurrentContext
        secondVC.transitioningDelegate = self.transition
        
        //   self.navigationController?.pushViewController(secondVC, animated: true)
        
        self.present(secondVC, animated: true, completion: nil)
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
