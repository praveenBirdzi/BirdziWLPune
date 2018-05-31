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
class Store: UIViewController , UITableViewDataSource,UITableViewDelegate,GMSMapViewDelegate  {
    var storeArray :NSArray = []
    @IBOutlet weak var homeView: UIView!
   // var stores = [storeModel]()
   // var storeArray = [storeModel]()
    @IBOutlet weak var storeDetails: UIView!
    @IBOutlet weak var popViewMapView: GMSMapView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!

    @IBOutlet weak var homeStoreName: UILabel!
    @IBOutlet weak var homeStoreDistance: UILabel!
    var zipString:String = ""
//    var custIDString:String = ""
//    var custKeyString:String = ""
    let defaults = UserDefaults.standard
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
        zipString = self.defaults.string(forKey: "zip")!
//        custIDString = self.defaults.string(forKey: "customerid")!
//        custKeyString = self.defaults.string(forKey: "customersharedsecret")!
      //  mySegmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.redColor()], forState: UIControlState.Selected)
        mySegmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.black], for: .selected)
        mySegmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.blue], for: .normal)
        self.storeDetails.isHidden = true
        self.storeDetails.frame = CGRect(origin: CGPoint(x: 0,y :  self.view.frame.height), size: CGSize(width: self.view.frame.width , height:  self.storeDetails.frame.size.height ))
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let store : NSDictionary = storeArray.object(at: indexPath.row) as! NSDictionary
       self.storeName.text =  String(format: "%@", store.value(forKey: "name") as! String)
        self.callBtn.setTitle(String(format: "%@", store.value(forKey: "phone") as! String), for: .normal)
    //    self.timeLbl.text =  String(format: "%@", store.value(forKey: "phone") as! String)
         self.timeLbl.text =  String(format: "%@", store.value(forKey: "storehours") as! String)
        let latitude = store.value(forKey: "latitude") as! Double
        let longitude = store.value(forKey: "longitude") as! Double
        var bounds = GMSCoordinateBounds()

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude:latitude, longitude:longitude)
//        let fancy = GMSCameraPosition.camera(withLatitude: latitude,
//                                 longitude: longitude,
//                                 zoom: 6,
//                                 bearing: 270,
//                                 viewingAngle: 45)
//        popViewMapView.camera = fancy

        // I have taken a pin image which is a custom image
        let markerImage = UIImage(named: "pin.png")!.withRenderingMode(.alwaysTemplate)
        
        //creating a marker view
        let markerView = UIImageView(image: markerImage)
        marker.title = store.value(forKey: "name") as! String
        marker.icon = markerImage
        marker.snippet = String(format: "%@ \n%@", store.value(forKey: "apptitle1") as! String,store.value(forKey: "apptitle2") as! String)
        marker.map = self.popViewMapView
        bounds = bounds.includingCoordinate(marker.position)
        self.popViewMapView.selectedMarker = marker
        let target = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.popViewMapView.camera = GMSCameraPosition.camera(withTarget: target, zoom: 12)
   // let update = GMSCameraUpdate.setCamera(GMSCameraPosition)
   //self.popViewMapView.animate(with: update)
       // self.popViewMapView.moveCamera(update)
        if(store.value(forKey: "isHomeStore") as! Bool)
        {
             self.doneBtn.isEnabled = false
            self.doneBtn.setTitle("Home Store", for: .normal)
            let markerImage = UIImage(named: "home_store_marker.png")!.withRenderingMode(.alwaysTemplate)
            
            //creating a marker view
            marker.icon = markerImage
        }
        else
        {
            self.doneBtn.isEnabled = true
            self.doneBtn.setTitle("Set as Home", for: .normal)
        }
        self.doneBtn.tag = store.value(forKey: "storeid") as! Int

        
        UIView.animate(withDuration: 0.8,  animations: {
            self.storeDetails.isHidden = false
            self.storeDetails.frame = CGRect(origin: CGPoint(x: 0,y : self.view.frame.size.height - self.storeDetails.frame.height - 110), size: CGSize(width: self.view.frame.width , height:  self.storeDetails.frame.size.height ))
              self.view.bringSubview(toFront: self.storeDetails)
        }, completion: { value in
            
        })
    }
    @objc func connected(sender: UIButton){
        let buttonTag = sender.tag
         let store : NSDictionary = storeArray.object(at: buttonTag) as! NSDictionary
        self.setSoreAPICall(homeStoreID: String(format: "%d", store.value(forKey: "storeid") as! Int)  )
    }
    @IBAction func callBtn(_ sender: UIButton) {
        sender.titleLabel?.text?.makeAColl()

    }
    @IBAction func downBtn(_ sender: UIButton) {
        UIView.animate(withDuration: 0.8,  animations: {
            self.storeDetails.isHidden = false
            self.storeDetails.frame = CGRect(origin: CGPoint(x: 0,y : self.view.frame.size.height+self.view.frame.size.height ), size: CGSize(width: self.view.frame.width , height:  self.storeDetails.frame.size.height ))
            self.view.bringSubview(toFront: self.storeDetails)
        }, completion: { value in
            
        })
    }
    @IBAction func mainDoneBtn(_ sender: UIButton) {
      
    }
    @IBAction func setHomeBtn(_ sender: UIButton) {
        let buttonTag = self.doneBtn.tag
         self.setSoreAPICall(homeStoreID: String(format: "%d", buttonTag))
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
    
    func getSoreAPICall() {
        SVProgressHUD.show()
        //DispatchQueue.global(qos: .userInitiated).async {
        
        let headers: HTTPHeaders = [
            "appkey": GlobalVariables.globalAppKey,
            "companyid" : GlobalVariables.globalCompanyId,
            "deviceid" : "020000000000",
            "customerid": self.defaults.string(forKey: "customerid")!,
            "customerkey": self.defaults.string(forKey: "customersharedsecret")!,
            "devicetypecode": "iphone",
            "devicetoken": "1",
            "zip": self.zipString,
            "distance":"10000",
            "browsestoreid": String(format: "%d",self.defaults.integer(forKey: "browsestoreId")),
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
                                    let markerImage = UIImage(named: "pin.png")!.withRenderingMode(.alwaysTemplate)
                                    
                                    //creating a marker view
                                     for datas in self.storeArray
                                    {
                                         let store : NSDictionary = datas as! NSDictionary
                                        let latitude = store.value(forKey: "latitude") as! Double
                                        let longitude = store.value(forKey: "longitude") as! Double
                                        
                                        let marker = GMSMarker()
                                        marker.position = CLLocationCoordinate2D(latitude:latitude, longitude:longitude)
                                        let markerImage = UIImage(named: "pin.png")!.withRenderingMode(.alwaysTemplate)
                                        
                                        //creating a marker view
                                        marker.icon = markerImage
                                        if(store.value(forKey: "isHomeStore") as! Bool)
                                        {
                                            self.homeView.isHidden = false
                                            self.myTableView.frame = CGRect(origin: CGPoint(x: self.homeView.frame.origin.x ,y :self.homeView.frame.origin.y + self.homeView.frame.size.height + 10) , size: CGSize(width: self.homeView.frame.width , height:  self.myTableView.frame.size.height ))
                                            
                                         self.homeStoreName.text = String(format: "%@ \n%@ \n%@", store.value(forKey: "name") as! String,store.value(forKey: "apptitle1") as! String,store.value(forKey: "apptitle2") as! String)
                                         self.homeStoreDistance.text = String(format: "%0.2f miles", store.value(forKey: "distance") as! Double)
                                            let markerImage = UIImage(named: "home_store_marker.png")!.withRenderingMode(.alwaysTemplate)
                                            
                                            //creating a marker view
                                            marker.icon = markerImage
                                        }
                                        
                
                           
 
 
                                        // I have taken a pin image which is a custom image
                                        
                                        
                                        //creating a marker view
                                        marker.title = store.value(forKey: "name") as? String
 
                                        marker.snippet = String(format: "%@ \n%@", store.value(forKey: "apptitle1") as! String,store.value(forKey: "apptitle2") as! String)
                                             marker.map = self.gmsMapView
                                            bounds = bounds.includingCoordinate(marker.position)
                                  //      self.gmsMapView.selectedMarker = marker
                                        
                                    }
                                    let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
                                    self.gmsMapView.animate(with: update)
                                    self.gmsMapView.delegate = self
                                    self.myTableView.reloadData()

                                    
                                }
 
                            }
                                
                            else
                            {
                                let snackbar = TTGSnackbar(message: "Data not Found", duration: .long)
                                snackbar.messageTextColor = .red
                                snackbar.show()
                                
                            }
                       
                        }
                        
                    }
                 }
                
       
                
            }
            else if(data.isFailure) {
                let dataString = String(data: data.value as! Data, encoding: String.Encoding.utf8)
                let snackbar = TTGSnackbar(message: dataString!, duration: .short)
                snackbar.show()
            }
        })
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if( mapView == self.gmsMapView)
        {
            for datas in self.storeArray
            {
                let store : NSDictionary = datas as! NSDictionary
               

                if(store.value(forKey: "name") as! String == marker.title)
                {
                    let latitude = store.value(forKey: "latitude") as! Double
                    let longitude = store.value(forKey: "longitude") as! Double
                    var bounds = GMSCoordinateBounds()
                    
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude:latitude, longitude:longitude)
                    let markerImage = UIImage(named: "pin.png")!.withRenderingMode(.alwaysTemplate)
                    
                    if(store.value(forKey: "isHomeStore") as! Bool)
                    {
                         self.doneBtn.isEnabled = false
                        self.doneBtn.setTitle("Home Store", for: .normal)
                        let markerImage = UIImage(named: "home_store_marker.png")!.withRenderingMode(.alwaysTemplate)
                        
                        //creating a marker view
                        marker.icon = markerImage
                    }
                    else
                    {
                        self.doneBtn.isEnabled = true
                        self.doneBtn.setTitle("Set as Home", for: .normal)
                    }
                    self.storeName.text =  String(format: "%@", store.value(forKey: "name") as! String)
                    self.callBtn.setTitle(String(format: "%@", store.value(forKey: "phone") as! String), for: .normal)
                    //    self.timeLbl.text =  String(format: "%@", store.value(forKey: "phone") as! String)
                    self.timeLbl.text =  String(format: "%@", store.value(forKey: "storehours") as! String)
                  
                    //        let fancy = GMSCameraPosition.camera(withLatitude: latitude,
                    //                                 longitude: longitude,
                    //                                 zoom: 6,
                    //                                 bearing: 270,
                    //                                 viewingAngle: 45)
                    //        popViewMapView.camera = fancy
                    
                    // I have taken a pin image which is a custom image
                    
                    //creating a marker view
                     marker.title = store.value(forKey: "name") as! String
                    marker.snippet = String(format: "%@ \n%@", store.value(forKey: "apptitle1") as! String,store.value(forKey: "apptitle2") as! String)
                    marker.map = self.popViewMapView
                    bounds = bounds.includingCoordinate(marker.position)
                    self.popViewMapView.selectedMarker = marker
                    let target = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    self.popViewMapView.camera = GMSCameraPosition.camera(withTarget: target, zoom: 12)
                    // let update = GMSCameraUpdate.setCamera(GMSCameraPosition)
                    //self.popViewMapView.animate(with: update)
                    // self.popViewMapView.moveCamera(update)
                    self.doneBtn.tag = store.value(forKey: "storeid") as! Int
                    
                    UIView.animate(withDuration: 0.8,  animations: {
                        self.storeDetails.isHidden = false
                        self.storeDetails.frame = CGRect(origin: CGPoint(x: 0,y : self.view.frame.size.height - self.storeDetails.frame.height - 110), size: CGSize(width: self.view.frame.width , height:  self.storeDetails.frame.size.height ))
                        self.view.bringSubview(toFront: self.storeDetails)
                    }, completion: { value in
                        
                    })
                }
            }
            print(marker)
        }
        
        print("didTapInfoWindowOf")
    }
    
    func setSoreAPICall(homeStoreID:String) {
        SVProgressHUD.show()
        DispatchQueue.global(qos: .userInitiated).async {
        
        let headerArr: HTTPHeaders = [
            "appkey": GlobalVariables.globalAppKey,
            "customerid": GlobalVariables.globalCustID,
            "customerkey": GlobalVariables.globalCustKey,
            "companyid" : GlobalVariables.globalCompanyId,
            "deviceid" : "020000000000",
            "homestoreid": homeStoreID,
            "modifiedbycontactid" : "",
            "browsestoreid" : String(format: "%d",self.defaults.integer(forKey: "browsestoreId")),
            "locale" : "ENGLISH"
        ]
        //      Birdzi@123
        //   print(NSLocale.current.languageCode)
        print(headerArr)
            print( self.defaults.string(forKey: "customerid")! )
            print( self.defaults.string(forKey: "customersharedsecret")! )

        APIUtilities.sharedInstance.putReqURL(setHomeStorUrl, parameters: [:], headers: headerArr, completion:  {
            (req, res, data)  -> Void in
            SVProgressHUD.dismiss()
            if(data.isSuccess) {
                
                //        let dataArr = ((data.value as AnyObject).value(forKey: "BookMyShow") as! NSDictionary).value(forKey: "arrEvent") as! NSArray
                if let results = (data.value as AnyObject) as? NSDictionary {
                    print ("\(results) results found")
                    //    let list = results.allValues.first as! NSArray
                    if (results.value(forKey: "statusCode") as! Int != 0)
                    {
                       
                            if(results.value(forKey: "status") as! Int == 11111)
                            {
                                
                                    
                                    let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! Home
                                
                            //        self.defaults.set(true, forKey:"isHomeSet")

                                    self.navigationController?.pushViewController(secondVC, animated: true)
                                    
                                
                                //   self.defaults.set(true, forKey:"hasLogin")
                                
                            }
                                
                            else
                            {
                                let snackbar = TTGSnackbar(message: "Unknown Error could not process the request.", duration: .long)
                                snackbar.messageTextColor = .red
                                snackbar.show()
                                
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

}
extension String {
    
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }
    
    func isValid(regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }
    
    func isValid(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    func makeAColl() {
        if isValid(regex: .phone) {
            if let url = URL(string: "tel://\(self.onlyDigits())"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
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
