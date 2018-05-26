//
//  Store.swift
//  Birdzi
//
//  Created by Dinesh Jagtap on 5/24/18.
//  Copyright © 2018 Birdzi. All rights reserved.
//

import UIKit
import GoogleMaps
import JTMaterialTransition
import SVProgressHUD
import TTGSnackbar
import Alamofire
class Store: UIViewController , UITableViewDataSource,UITableViewDelegate  {
    
    var storeArray :NSArray = []
    @IBOutlet weak var homeView: UIView!

   // var stores = [storeModel]()
   // var storeArray = [storeModel]()
    @IBOutlet weak var homeStoreName: UILabel!
    @IBOutlet weak var homeStoreDistance: UILabel!
    var zipString:String = ""
    var custIDString:String = ""
    var custKeyString:String = ""

    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var gmsMapView: GMSMapView!
    @IBOutlet weak var bgBlure: UIImageView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var searchTxt: UITextField!
    var transition: JTMaterialTransition?

    override func viewDidLoad() {
         self.transition = JTMaterialTransition(animatedView: self.menuBtn)
        self.transition?.transitionDuration = 0.6
        bgBlure.blurImage(frame: self.logoImg.frame)
        zipString = UserDefaults.standard.string(forKey: "zip")!
        custIDString = UserDefaults.standard.string(forKey: "customerid")!
        custKeyString = UserDefaults.standard.string(forKey: "customersharedsecret")!
      //  mySegmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.redColor()], forState: UIControlState.Selected)
        mySegmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.black], for: .selected)
        mySegmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.blue], for: .normal)

        self.getSoreAPICall()
        super.viewDidLoad()
        gmsMapView.isHidden = true

        // Do any additional setup after loading the view.
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storeCell", for: indexPath) as! storeCell
        let store : NSDictionary = storeArray.object(at: indexPath.row) as! NSDictionary
     
         cell.store_address.text = String(format: "%@ \n%@ \n%@", store.value(forKey: "name") as! String,store.value(forKey: "apptitle1") as! String,store.value(forKey: "apptitle2") as! String)
        cell.store_distance.text = String(format: "%0.2f miles", store.value(forKey: "distance") as! Double)
        cell.submitButton.tag = indexPath.row
     //   cell.submitButton.targetForAction("connected", withSender: self)
        cell.submitButton.addTarget(self, action: #selector(Store.connected(sender:)), for: .touchUpInside)

        return cell
    }
    @objc func connected(sender: UIButton){
        let buttonTag = sender.tag
         let store : NSDictionary = storeArray.object(at: buttonTag) as! NSDictionary
        self.setSoreAPICall(homeStoreID: String(format: "%d", store.value(forKey: "storeid") as! Int) ,custID: self.custIDString , custKey: self.custKeyString )
    }
    @IBAction func menuBtn(_ sender: UIButton) {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Menu") as! Menu
        //
        secondVC.modalPresentationStyle = .custom
        secondVC.transitioningDelegate = self.transition
        //
        secondVC.logo_img = #imageLiteral(resourceName: "ic_dorothy_settings_logo.png")
        self.present(secondVC,animated: true, completion: nil)
    }
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        mySegmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.black], for: .selected)
        mySegmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.blue], for: .normal)
        
        
        
        switch sender.selectedSegmentIndex {
        case 0:
            listView.isHidden = false
            gmsMapView.isHidden = true
        case 1:
            listView.isHidden = true
            gmsMapView.isHidden = false
        default:
            break;
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func getSoreAPICall() {
        SVProgressHUD.show()
        //DispatchQueue.global(qos: .userInitiated).async {
        
        let headers: HTTPHeaders = [
            "appkey": GlobalVariables.globalAppKey,
            "companyid" : GlobalVariables.globalCompanyId,
            "deviceid" : "020000000000",
            "customerid": self.custIDString,
           "customerkey": self.custKeyString,
            "devicetypecode": "iphone",
            "devicetoken": "1",
            "zip": self.zipString,
            "distance":"10000",
            "browsestoreid": String(format: "%d",UserDefaults.standard.integer(forKey: "browsestoreId")),
            "advertisingidentifier": "B691A224-537E-46B0-A629-9F3D096F12DD",
            "locale": "ENGLISH"
        ]
        //      Birdzi@123
     //   print(NSLocale.current.languageCode)
        print(headers)
        APIUtilities.sharedInstance.getReqURL(getStoreListWithZipUrl, parameters: [:], headers: headers, completion:  {
            (req, res, data)  -> Void in
            SVProgressHUD.dismiss()
            if(data.isSuccess) {
                
                //        let dataArr = ((data.value as AnyObject).value(forKey: "BookMyShow") as! NSDictionary).value(forKey: "arrEvent") as! NSArray
                if let results = (data.value as AnyObject) as? NSDictionary {
                    print ("\(results) results found")
                    //    let list = results.allValues.first as! NSArray
                    if (results.value(forKey: "statusCode") as! Int != 0)
                    {
                        if (results.value(forKey: "status") as! Int == 0)
                        {
                            if(results.value(forKey: "statusCode") as! Int == 11111)
                            {
                                if let details = (results.value(forKey: "data")) as? NSArray {
                                    self.storeArray = (results.value(forKey: "data") as? NSArray)!
                                    var bounds = GMSCoordinateBounds()

                                    for datas in self.storeArray
                                    {
                                         let store : NSDictionary = datas as! NSDictionary
                                        if(store.value(forKey: "isHomeStore") as! Bool)
                                        {
                                            self.homeView.isHidden = false
                                            self.myTableView.frame = CGRect(origin: CGPoint(x: self.homeView.frame.origin.x ,y :self.homeView.frame.origin.y + self.homeView.frame.size.height + 10) , size: CGSize(width: self.homeView.frame.width , height:  self.myTableView.frame.size.height ))
                                            
                                         self.homeStoreName.text = String(format: "%@ \n%@ \n%@", store.value(forKey: "name") as! String,store.value(forKey: "apptitle1") as! String,store.value(forKey: "apptitle2") as! String)
                                         self.homeStoreDistance.text = String(format: "%0.2f miles", store.value(forKey: "distance") as! Double)
                                        }
                           
                                            let latitude = store.value(forKey: "latitude") as! Double
                                            let longitude = store.value(forKey: "longitude") as! Double
                                            
                                            let marker = GMSMarker()
                                            marker.position = CLLocationCoordinate2D(latitude:latitude, longitude:longitude)
 
                                        // I have taken a pin image which is a custom image
                                        let markerImage = UIImage(named: "pin.png")!.withRenderingMode(.alwaysTemplate)
                                        
                                        //creating a marker view
                                        let markerView = UIImageView(image: markerImage)
                                        marker.title = store.value(forKey: "name") as! String
                                        marker.icon = markerImage
                                        marker.snippet = String(format: "%@ \n%@", store.value(forKey: "apptitle1") as! String,store.value(forKey: "apptitle2") as! String)
                                             marker.map = self.gmsMapView
                                            bounds = bounds.includingCoordinate(marker.position)
                                        self.gmsMapView.selectedMarker = marker
                                        
                                    }
                                    let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
                                    self.gmsMapView.animate(with: update)
                                    self.myTableView.reloadData()

                                    
                                }
                             //   UserDefaults.standard.set(true, forKey:"hasLogin")
                                
                            }
                                
                            else
                            {
                                let snackbar = TTGSnackbar(message: "Data not Found", duration: .long)
                                snackbar.messageTextColor = .red
                                snackbar.show()
                                
                            }
                            //                    if(results.value(forKey: "status") as! Int == 33333)
                            //                    {
                            //
                            //                    }
                        }
                        
                    }
                    //print (list)
                }
                
                //let dataString = String(data: data.value as! NSDictionary, encoding: String.Encoding.utf8)
                // let dataArr = ((data.value as AnyObject).value(forKey: "BookMyShow") as! NSDictionary).value(forKey: "arrEvent") as! NSArray
                //        let snackbar = TTGSnackbar(message: "Succsess Call", duration: .long)
                //        snackbar.show()
                
            }
            else if(data.isFailure) {
                let dataString = String(data: data.value as! Data, encoding: String.Encoding.utf8)
                let snackbar = TTGSnackbar(message: dataString!, duration: .short)
                snackbar.show()
            }
        })
    }
    func setSoreAPICall(homeStoreID:String , custID:String ,custKey:String) {
        SVProgressHUD.show()
        //DispatchQueue.global(qos: .userInitiated).async {
        
        let headers: HTTPHeaders = [
            "appkey": GlobalVariables.globalAppKey,
            "customerid": custID,
            "customerkey":custKey,
            "companyid" : GlobalVariables.globalCompanyId,
            "deviceid" : "020000000000",
            "homestoreid": homeStoreID,
            "modifiedbycontactid" : "",
            "browsestoreid" : String(format: "%d",UserDefaults.standard.integer(forKey: "browsestoreId")),
            "locale" : "ENGLISH"
        ]
        //      Birdzi@123
        //   print(NSLocale.current.languageCode)
        print(headers)
        APIUtilities.sharedInstance.putReqURL(setHomeStorUrl, parameters: [:], headers: headers, completion:  {
            (req, res, data)  -> Void in
            SVProgressHUD.dismiss()
            if(data.isSuccess) {
                
                //        let dataArr = ((data.value as AnyObject).value(forKey: "BookMyShow") as! NSDictionary).value(forKey: "arrEvent") as! NSArray
                if let results = (data.value as AnyObject) as? NSDictionary {
                    print ("\(results) results found")
                    //    let list = results.allValues.first as! NSArray
                    if (results.value(forKey: "statusCode") as! Int != 0)
                    {
                        if (results.value(forKey: "status") as! Int == 0)
                        {
                            if(results.value(forKey: "statusCode") as! Int == 11111)
                            {
                                
                                    
                                    let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! Home
                                
                            //        UserDefaults.standard.set(true, forKey:"isHomeSet")

                                    self.navigationController?.pushViewController(secondVC, animated: true)
                                    
                                
                                //   UserDefaults.standard.set(true, forKey:"hasLogin")
                                
                            }
                                
                            else
                            {
                                let snackbar = TTGSnackbar(message: "Unknown Error could not process the request.", duration: .long)
                                snackbar.messageTextColor = .red
                                snackbar.show()
                                
                            }
                            //                    if(results.value(forKey: "status") as! Int == 33333)
                            //                    {
                            //
                            //                    }
                        }
                        
                    }
                    //print (list)
                }
                
                //let dataString = String(data: data.value as! NSDictionary, encoding: String.Encoding.utf8)
                // let dataArr = ((data.value as AnyObject).value(forKey: "BookMyShow") as! NSDictionary).value(forKey: "arrEvent") as! NSArray
                //        let snackbar = TTGSnackbar(message: "Succsess Call", duration: .long)
                //        snackbar.show()
                
            }
            else if(data.isFailure) {
                let dataString = String(data: data.value as! Data, encoding: String.Encoding.utf8)
                let snackbar = TTGSnackbar(message: dataString!, duration: .short)
                snackbar.show()
            }
        })
    }

}
/*extension Store: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
    }
    
    /* handles Info Window long press */
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }
    
    /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        lbl1.text = "Hi there!"
        view.addSubview(lbl1)
        
        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
        lbl2.text = "I am a custom info window."
        lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.addSubview(lbl2)
        
        return view
    }
}
*/
