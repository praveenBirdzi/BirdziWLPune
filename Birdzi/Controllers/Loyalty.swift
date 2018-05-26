//
//  Loyalty.swift
//  Birdzi
//
//  Created by Dinesh Jagtap on 5/9/18.
//  Copyright © 2018 Birdzi. All rights reserved.
//

import UIKit
import SVProgressHUD
import TTGSnackbar
import Alamofire
class Loyalty: UIViewController ,UITextFieldDelegate {
    @IBOutlet weak var bgBlure: UIImageView!
     var responseArray = NSMutableArray()
    var finalData = NSMutableDictionary()
    let button = UIButton(type: UIButtonType.custom)

    @IBOutlet weak var loyltyTxt: UITextField!
    @IBOutlet weak var logoImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bgBlure.blurImage(frame: self.logoImg.frame)
        // Do any additional setup after loading the view.
    }
    @IBAction func skipLoylty(_ sender: UIButton) {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func APICall() {
        SVProgressHUD.show()
        //DispatchQueue.global(qos: .userInitiated).async {
        
        let headers: HTTPHeaders = [
            "appkey": GlobalVariables.globalAppKey,
            "companyid" : GlobalVariables.globalCompanyId,
            "deviceid" : GlobalVariables.globalDeviceId,
            "loyaltyno": self.loyltyTxt.text!,
            "locale": "ENGLISH"

        ]
        APIUtilities.sharedInstance.getReqURL(getLoyaltyValidateUrl, parameters: [:], headers: headers, completion:  {
            (req, res, data)  -> Void in
            SVProgressHUD.dismiss()
            if(data.isSuccess) {
                
                self.responseArray.removeAllObjects()
                //        let dataArr = ((data.value as AnyObject).value(forKey: "BookMyShow") as! NSDictionary).value(forKey: "arrEvent") as! NSArray
                if let results = (data.value as AnyObject) as? NSDictionary {
                    print ("\(results) results found")
                    //    let list = results.allValues.first as! NSArray
                    if (results.value(forKey: "statusCode") as! Int != 0)
                    {
                        if (results.value(forKey: "status") as! Int != 0)
                        {
                            if(results.value(forKey: "status") as! Int == 22222)
                            {
                                UserDefaults.standard.set(self.loyltyTxt.text!, forKey:"loyalty_no")
                                let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
                               // secondVC.stringPassed = ""
                                self.navigationController?.pushViewController(secondVC, animated: true)
                            }
                            else if(results.value(forKey: "status") as! Int == 44444)
                            {
                                let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
                               // secondVC.stringPassed = self.emailTxt.text!
                                UserDefaults.standard.set(self.loyltyTxt.text!, forKey:"loyalty_no")
                                
                                self.navigationController?.pushViewController(secondVC, animated: true)
                            }
                            else
                            {
                                let snackbar = TTGSnackbar(message: results.value(forKey: "message") as! String, duration: .long)
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
    //   }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("TextField should clear method called")
        textField.text = ""
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("TextField should return method called")
        let result = textField.text?.replacingOccurrences(of: " ", with: "",                                            options: NSString.CompareOptions.literal, range:nil)
        //f(result?.isEmail)! {
            textField.resignFirstResponder();
            textField.textColor = UIColor(hexString: "#424B24")
            //  print("email is valid")
            self.APICall()
            //            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Password") as! Password
            //            secondVC.stringPassed = textField.text!
            //            self.navigationController?.pushViewController(secondVC, animated: true)
            return true;
            
//        } else {
//            textField.becomeFirstResponder();
//            // print("email is not valid")
//            textField.textColor = .red
//            return false;
//
//        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        textField.textColor = UIColor(hexString: "#424B24")
        
        return true;
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
