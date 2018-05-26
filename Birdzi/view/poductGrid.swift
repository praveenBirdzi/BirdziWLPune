//
//  poductGrid.swift
//  Birdzi
//
//  Created by Dinesh Jagtap on 4/23/18.
//  Copyright © 2018 Birdzi. All rights reserved.
//

import UIKit
import SDWebImage
@IBDesignable class poductGrid: UIView,UICollectionViewDelegate,UICollectionViewDataSource{
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var productCollection: UICollectionView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    var productArr :NSMutableArray = GlobalVariablesArr.globalProductArr
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("poductGrid", owner: self, options: nil)
       self.mainView.frame = bounds
        self.productArr   = GlobalVariablesArr.globalProductArr
        self.titleLbl.text = GlobalVariables.globalString
        self.productCollection.delegate = self;
        self.productCollection.dataSource = self;
        self.productCollection.register(UINib(nibName: "productCell", bundle: nil), forCellWithReuseIdentifier: "cell")

       // self.productCollection.register(productCell.self, forCellWithReuseIdentifier: "cell")
        self.addSubview(self.mainView)
        self.addSubview(self.productCollection)
        self.addSubview(self.titleLbl)
        self.addSubview(self.imgView)
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
      
        //  fatalError("init(coder:) has not been implemented")
    }
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1     //return number of sections in collection view
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     //   print(productArr)
        // get a reference to our storyboard cell
      //  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! productCell
        var cell: productCell! = collectionView.dequeueReusableCell(withReuseIdentifier:  "cell", for:  indexPath as IndexPath) as? productCell
        if cell == nil {
            collectionView.register(UINib(nibName: "productCell", bundle: nil), forCellWithReuseIdentifier: "cell")
         //   collectionView.register(UINib(nibName: "productCell", bundle: nil), forCellReuseIdentifier: "cell")
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for:  indexPath as IndexPath) as? productCell
        }
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.cost.text = (self.productArr[indexPath.row] as! NSDictionary).value(forKey: "title") as? String
        cell.title.text = (self.productArr[indexPath.row] as! NSDictionary).value(forKey: "description") as? String
        let thumb = (self.productArr[indexPath.row] as! NSDictionary).value(forKey: "url")  as? String
        let url = URL(string: thumb!)
        let str = (self.productArr[indexPath.row] as! NSDictionary).value(forKey: "id") as? NSNumber

        if(titleLbl.text == "Offers")
        {
            
            if GlobalVariablesArr.globalOfferArr.contains(str as Any) {
                cell.bottomView.backgroundColor = .orange
                cell.cartButton.setImage(#imageLiteral(resourceName: "check-mark-button.png"), for: .normal)
                cell.type.text = "Cliped"
            }
            else
            {
            //    rgb(34,139,34)

               cell.bottomView.backgroundColor =  UIColor( red: CGFloat(34/255.0), green: CGFloat(139/255.0), blue: CGFloat(34/255.0), alpha: CGFloat(1.0) )
            cell.cartButton.setImage(#imageLiteral(resourceName: "clip.png"), for: .normal)
            cell.type.text = "Clip"
            }
        }
        else
        {
             if GlobalVariablesArr.globalListArr.contains(str as Any) {
           cell.bottomView.backgroundColor =  UIColor( red: CGFloat(34/255.0), green: CGFloat(139/255.0), blue: CGFloat(34/255.0), alpha: CGFloat(1.0) )
                cell.cartButton.setImage(#imageLiteral(resourceName: "check-mark-button.png"), for: .normal)
                cell.type.text = "Added List"
            }
            else
             {
            cell.bottomView.backgroundColor = .lightGray
            cell.cartButton.setImage(#imageLiteral(resourceName: "add-button.png"), for: .normal)
            cell.type.text = "Add Product"
            }

        }
         cell.cartButton.tag = indexPath.row // Button 1
         cell.cartButton.addTarget(self, action: #selector(addBtn(_:)), for: .touchUpInside)
         cell.imgView?.sd_setImage(with:url, placeholderImage: UIImage(named: "loadding.jpg"))
        
        //    cell.imageView?.image = UIImage(named:)
     //   cell.imgView?.contentMode = .scaleAspectFill
        cell.imgView?.clipsToBounds = true
        //cell.menu_img.image = self.imgArr[indexPath.row] as! UIImage
      //  cell.imgView.image = self.imgArr[indexPath.row] as? UIImage
        
        //  cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
    @objc func addBtn(_ sender: AnyObject) -> Int {
        print("clicked")
      //  self.callNumber((sender.titleLabel?!.text)!)
        if(titleLbl.text == "Offers")
        {
             let str = (self.productArr[sender.tag] as! NSDictionary).value(forKey: "id") as? NSNumber
            GlobalVariablesArr.globalOfferArr.add(str!)
            // defaults.set(jsonResult.value(forKey: "bookings") as! String, forKey: "bookings")
            UserDefaults.standard.set(GlobalVariablesArr.globalOfferArr, forKey:"offer_arr")
            self.productCollection.reloadData()

        }
        else
        {
            let str = (self.productArr[sender.tag] as! NSDictionary).value(forKey: "id") as? NSNumber
            GlobalVariablesArr.globalListArr.add(str!)
            UserDefaults.standard.set(GlobalVariablesArr.globalListArr, forKey:"listArr")
            self.productCollection.reloadData()

        }
        return 1
     }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentController = UIApplication.topViewController()
        let secondVC = currentController?.storyboard?.instantiateViewController(withIdentifier: "productDetailVC") as! productDetailVC
        
        if(titleLbl.text == "Offers")
        {
            secondVC.titleTxt = "Offer Detail Screen"

        }
        else
        {
            secondVC.titleTxt = "Product Detail Screen"

        }
        currentController?.navigationController?.pushViewController(secondVC, animated: true)

    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
