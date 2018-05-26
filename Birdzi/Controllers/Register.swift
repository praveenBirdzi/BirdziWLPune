//
//  Register.swift
//  Birdzi
//
//  Created by Dinesh Jagtap on 5/2/18.
//  Copyright © 2018 Birdzi. All rights reserved.
//

import UIKit
import SVProgressHUD
import TTGSnackbar
import Alamofire
import TextFieldEffects
class Register: UIViewController,UITextFieldDelegate {
  @IBOutlet weak var bgBlure: UIImageView!
    @IBOutlet weak var logoImg: UIImageView!
    var responseArray = NSMutableArray()
    var finalData = NSMutableDictionary()
    @IBOutlet weak var scrollView: UIScrollView!
    let button = UIButton(type: UIButtonType.custom)

    @IBOutlet weak var emailTxt: KaedeTextField!
    @IBOutlet weak var firstNamext: KaedeTextField!
    @IBOutlet weak var lastNameTxt: KaedeTextField!
    @IBOutlet weak var phoneTxt: KaedeTextField!
    @IBOutlet weak var zipTxt: KaedeTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        bgBlure.blurImageNew(frame: self.logoImg.frame)
        button.setTitle("Return", for: UIControlState())
        button.setTitleColor(UIColor.black, for: UIControlState())
        button.frame = CGRect(x: 0, y: 163, width: 106, height: 53)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(Register.Done(_:)), for: UIControlEvents.touchUpInside)
        self.emailTxt.text = UserDefaults.standard.string(forKey: "login_email")!
        self.emailTxt.isEnabled = false
        // Do any additional setup after loading the view.
    }
    @objc func Done(_ sender : UIButton){
        
        DispatchQueue.main.async { () -> Void in
            
            self.phoneTxt.resignFirstResponder()
            self.zipTxt.resignFirstResponder()

            }
    }
    @objc func keyboardWillShow(_ note : Notification) -> Void{
        DispatchQueue.main.async { () -> Void in
            self.button.isHidden = false
            let keyBoardWindow = UIApplication.shared.windows.last
            self.button.frame = CGRect(x: 0, y: (keyBoardWindow?.frame.size.height)!-53, width: 106, height: 53)
            keyBoardWindow?.addSubview(self.button)
            keyBoardWindow?.bringSubview(toFront: self.button)
            
            UIView.animate(withDuration: (((note.userInfo! as NSDictionary).object(forKey: UIKeyboardAnimationCurveUserInfoKey) as AnyObject).doubleValue)!, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: 0)
            }, completion: { (complete) -> Void in
                print("Complete")
            })
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if ( textField == self.firstNamext ) {
            lastNameTxt.becomeFirstResponder()
        }
        else if ( textField == self.lastNameTxt )
        {
             phoneTxt.becomeFirstResponder()
            
           
            
        }
       
        else if ( textField == self.phoneTxt )
        {
            let sz = CGSize(width: 0, height: scrollView.frame.height+10)
            zipTxt.becomeFirstResponder()
            
            self.scrollView.contentSize = sz
            scrollView .setContentOffset( CGPoint(x: 0,y: 0), animated: true)
            
        }
        else if ( textField == self.zipTxt )
        {
            self.view.endEditing(true)
            let sz = CGSize(width: 0, height: view.frame.height+50)
            
            self.scrollView.contentSize = sz
            scrollView .setContentOffset( CGPoint(x: 0,y: 0), animated: true)
            
        }
        else
        {
            self.view.endEditing(true)
            let sz = CGSize(width: 0, height: view.frame.height+130)
            
            self.scrollView.contentSize = sz
            scrollView .setContentOffset( CGPoint(x: 0,y: 0), animated: true)
            
        }
        
        return true;
    }
    func REGAPICall() {
        SVProgressHUD.show()
        //DispatchQueue.global(qos: .userInitiated).async {
        
        let headers: HTTPHeaders = [
            "appkey": GlobalVariables.globalAppKey,
            "companyid" : GlobalVariables.globalCompanyId,
            "deviceid" : "020000000000",
            "email": UserDefaults.standard.string(forKey: "login_email")!,
            "password" : UserDefaults.standard.string(forKey: "login_password")!,
            "firstname" : self.firstNamext.text!,
            "lastname" : self.lastNameTxt.text!,
            "zip" : self.zipTxt.text!,
            "phone" : self.phoneTxt.text!,
            "yob" : "0",
            "city" : "0",
            "gender" : "",
            "state" : "0",
            "loyaltyno":"",
            "birthdate": "",
            "address1": "",
            "address2" :"",
            "country" : "0"
         ]
        APIUtilities.sharedInstance.requestURL(getRegisterUrl, parameters: [:], headers: headers, completion:  {
            (req, res, data)  -> Void in
            SVProgressHUD.dismiss()
            if(data.isSuccess) {
                
                //        let dataArr = ((data.value as AnyObject).value(forKey: "BookMyShow") as! NSDictionary).value(forKey: "arrEvent") as! NSArray
                if let results = (data.value as AnyObject) as? NSDictionary {
                    print ("\(results) results found")
                    //    let list = results.allValues.first as! NSArray
                    if (results.value(forKey: "status") as! Int != 0 && results.value(forKey: "status") as! Int != 400 )
                    {
                        if (results.value(forKey: "statusCode") as! Int != 0)
                        {
                            if(results.value(forKey: "status") as! Int == 22222)
                            {
                                if let details = (results.value(forKey: "data")) as? NSDictionary {
                                    UserDefaults.standard.set(details.value(forKey: "customerid") as! Int, forKey:"customerid")
                                    UserDefaults.standard.set(details.value(forKey: "browsestoreId") as! Int, forKey:"browsestoreId")
                                    UserDefaults.standard.set(details.value(forKey: "zip") as! String, forKey:"zip")
                                    UserDefaults.standard.set(details.value(forKey: "customersharedsecret") as! String, forKey:"customersharedsecret")

                                    UserDefaults.standard.set(String(format:" %@ %@ ", details.value(forKey: "apptitle1") as! String, details.value(forKey: "apptitle2") as! String), forKey:"storeName")
                                    
                                }
                                let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! Home
                                self.navigationController?.pushViewController(secondVC, animated: true)
                            }
                           
                            else
                            {
                                let snackbar = TTGSnackbar(message: results.value(forKey: "message") as! String, duration: .long)
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func doneBtn(_ sender: UIButton) {
        if ((self.firstNamext.text?.characters.count)! > 0)
        {
            if ((self.lastNameTxt.text?.characters.count)! > 0)
            {
                if ((self.phoneTxt.text?.characters.count)! > 0)
                {
                    if ((self.zipTxt.text?.characters.count)! > 0)
                    {
                        self.REGAPICall()
                    }
                    else
                    {
                         let snackbar = TTGSnackbar(message:"zip required", duration: .short)
                        snackbar.show()
                    }
                }
                else
                {
                    let snackbar = TTGSnackbar(message:"phone required", duration: .short)
                    snackbar.show()
                }
            }
            else
            {
                let snackbar = TTGSnackbar(message:"last name required", duration: .short)
                snackbar.show()
            }
        }
        else
        {
            let snackbar = TTGSnackbar(message:"first name required", duration: .short)
            snackbar.show()
        }
    }
    @IBAction func cancelBtn(_ sender: UIButton) {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        NotificationCenter.default.addObserver(self, selector: #selector(Register.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
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
