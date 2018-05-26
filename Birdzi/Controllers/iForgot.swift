//
//  iForgot.swift
//  Birdzi
//
//  Created by Dinesh Jagtap on 4/17/18.
//  Copyright © 2018 Birdzi. All rights reserved.
//

import UIKit
import SVProgressHUD
import TTGSnackbar
import Alamofire
class iForgot: UIViewController ,UITextFieldDelegate {
    var stringPassed = ""
    @IBOutlet weak var bgBlure: UIImageView!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var otpTxt1: UITextField!
    @IBOutlet weak var otpTxt2: UITextField!
    @IBOutlet weak var otpTxt3: UITextField!
    @IBOutlet weak var otpTxt4: UITextField!
    @IBOutlet weak var otpTxt5: UITextField!
    @IBOutlet weak var otpTxt6: UITextField!
    var verificationPassed = ""
    @IBOutlet weak var nextButton: UIButton!
    var otp : Int = 0
    var stringGet = ""

    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailLbl.text = stringPassed;
         bgBlure.blurImage(frame: self.logoImg.frame)
      //  print("Generated Home : \(fourDigitNumber)")
        otpTxt1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        otpTxt2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        otpTxt3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        otpTxt4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
          otpTxt5.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        otpTxt6.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        otp = randomNumberWith(digits:6)
        APICall();
        self.hideKeyboard()
        // Do any additional setup after loading the view.
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let text = textField.text
        
        let  char = text?.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if isBackSpace == -92 {
            
         //   switch textField{
//            case otpTxt1:
//                otpTxt1.text = ""
//
//                otpTxt1.resignFirstResponder()
//            case otpTxt2:
//                otpTxt2.text = ""
//
//                otpTxt1.becomeFirstResponder()
//            case otpTxt3:
//                otpTxt3.text = ""
//
//                otpTxt2.becomeFirstResponder()
//            case otpTxt4:
//                otpTxt4.text = ""
//
//                otpTxt3.becomeFirstResponder()
//            case otpTxt5:
//                otpTxt5.text = ""
//
//                otpTxt4.becomeFirstResponder()
//            case otpTxt6:
//                otpTxt6.text = ""
//                otpTxt5.becomeFirstResponder()
//            default:
//                break
//            }
            return true;
            
        }
        else
        {
        return true
        }
        
    }
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case otpTxt1:
                otpTxt2.becomeFirstResponder()
            case otpTxt2:
                otpTxt3.becomeFirstResponder()
            case otpTxt3:
                otpTxt4.becomeFirstResponder()
            case otpTxt4:
                otpTxt5.becomeFirstResponder()
            case otpTxt5:
                otpTxt6.becomeFirstResponder()
            case otpTxt6:
                    otpTxt6.resignFirstResponder()
                    self.nextButton.isHidden = false

            default:
                break
            }
        }
//        if  text?.count == 0 {
//            switch textField{
//            case otpTxt1:
//                otpTxt1.becomeFirstResponder()
//            case otpTxt2:
//                otpTxt1.becomeFirstResponder()
//            case otpTxt3:
//                otpTxt2.becomeFirstResponder()
//            case otpTxt4:
//                otpTxt3.becomeFirstResponder()
//            case otpTxt5:
//                otpTxt4.becomeFirstResponder()
//            case otpTxt6:
//                otpTxt5.becomeFirstResponder()
//            default:
//                break
//            }
//        }
        else{
            
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        let text = textField.text

        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if isBackSpace == -92 {

            switch textField{
            case otpTxt1:
                otpTxt1.text = ""

                otpTxt1.resignFirstResponder()
            case otpTxt2:
                otpTxt2.text = ""

                otpTxt1.becomeFirstResponder()
            case otpTxt3:
                otpTxt3.text = ""

                otpTxt2.becomeFirstResponder()
            case otpTxt4:
                otpTxt4.text = ""

                otpTxt3.becomeFirstResponder()
            case otpTxt5:
                otpTxt5.text = ""

                otpTxt4.becomeFirstResponder()
            case otpTxt6:
                otpTxt6.text = ""
                otpTxt5.becomeFirstResponder()
            default:
                break
            }
            return false;

        }
        else
        {
        if  text?.count == 1 {
            switch textField{
            case otpTxt1:
                otpTxt2.becomeFirstResponder()
            case otpTxt2:
                otpTxt3.becomeFirstResponder()
            case otpTxt3:
                otpTxt4.becomeFirstResponder()
            case otpTxt4:
                otpTxt5.becomeFirstResponder()
            case otpTxt5:
                otpTxt6.becomeFirstResponder()
            case otpTxt6:
                otpTxt6.resignFirstResponder()
               
                self.nextButton.isHidden = false

            default:
                break
            }
        }
//        if  text?.count == 0 {
//            switch textField{
//            case otpTxt1:
//                otpTxt1.becomeFirstResponder()
//            case otpTxt2:
//                otpTxt1.becomeFirstResponder()
//            case otpTxt3:
//                otpTxt2.becomeFirstResponder()
//            case otpTxt4:
//                otpTxt3.becomeFirstResponder()
//            case otpTxt5:
//                otpTxt4.becomeFirstResponder()
//            case otpTxt6:
//                otpTxt5.becomeFirstResponder()
//            default:
//                break
//            }
//        }
        
         return true;
        }
      //  return true;

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturnSingle(_ textField: UITextField , newString : String)
    {
        let nextTag: Int = textField.tag + 1
        
        let nextResponder: UIResponder? = textField.superview?.superview?.viewWithTag(nextTag)
        textField.text = newString
        if let nextR = nextResponder
        {
            // Found next responder, so set it.
            nextR.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard.
            textField.textColor = UIColor(hexString: "#424B24")
            self.nextButton.isHidden = false
            textField.resignFirstResponder()
        }
    }
    @IBAction func callBtn(_ sender: UIButton) {
      //  self.navigationController?.popViewController(animated: true)
//        if let url = NSURL(string: "tel://+91 9325894169"), UIApplication.shared.canOpenURL(url as URL) {
//            UIApplication.shared.openURL(url as URL)
//        }
    }
    @IBAction func resendBtn(_ sender: UIButton) {
        self.otpTxt1.text = ""
        self.otpTxt2.text = ""
        self.otpTxt3.text = ""
        self.otpTxt4.text = ""
        self.otpTxt5.text = ""
        self.otpTxt6.text = ""
        self.nextButton.isHidden = true
        otp = randomNumberWith(digits:6)

        APICall();
        let snackbar = TTGSnackbar(message: "code re-sent", duration: .long)
        snackbar.messageTextColor = .green
        snackbar.show()
       // self.navigationController?.popViewController(animated: true)
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func nextBtn(_ sender: UIButton) {
         self.stringPassed = String(format: "%@%@%@%@%@%@", otpTxt1.text!,otpTxt2.text!,otpTxt3.text!,otpTxt4.text!,otpTxt5.text!,otpTxt6.text!)
        stringGet = String(format: "%d", otp);
        if(stringGet == stringPassed)
        {
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! Home
        //    secondVC.isReset = true
            UserDefaults.standard.set(true, forKey:"hasLogin")

            self.navigationController?.pushViewController(secondVC, animated: true)
        }
        else
        {
            let snackbar = TTGSnackbar(message: "hmm. that didn't work", duration: .long)
            snackbar.messageTextColor = .red
            snackbar.show()
        }
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    func APICall() {
        SVProgressHUD.show()
        //DispatchQueue.global(qos: .userInitiated).async {
        
        let headers: HTTPHeaders = [
            "appkey": GlobalVariables.globalAppKey,
            "companyid" : GlobalVariables.globalCompanyId,
            "deviceid" : "020000000000",
            "email": UserDefaults.standard.string(forKey: "login_email")!,
            "mobileotp": String(format: "%d", otp)
        ]
        APIUtilities.sharedInstance.getReqURL(getForgotPassUrl, parameters: [:], headers: headers, completion:  {
            (req, res, data)  -> Void in
            SVProgressHUD.dismiss()
            if(data.isSuccess) {
                
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
                                let snackbar = TTGSnackbar(message: results.value(forKey: "message") as! String, duration: .long)
                                snackbar.messageTextColor = .green
                                snackbar.show()
                            }
                             
                            else
                            {
                                let snackbar = TTGSnackbar(message: results.value(forKey: "message") as! String, duration: .long)
                                snackbar.messageTextColor = .red
                                
                                snackbar.show()
                                
                            }
                            
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
    func randomNumberWith(digits:Int) -> Int {
        let min = Int(pow(Double(10), Double(digits-1))) - 1
        let max = Int(pow(Double(10), Double(digits))) - 1
        return Int(Range(uncheckedBounds: (min, max)))
    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        let newString = ((textField.text)! as NSString).replacingCharacters(in: range, with: string)
//
//        let newLength = newString.characters.count
//
//        if newLength == 1 {
//            textFieldShouldReturnSingle(textField , newString : newString)
//            return false
//        }
//
//        return true
//    }
    
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
//var fourDigitNumber: String {
//    var result = ""
//    repeat {
//        // Create a string with a random number 0...9999
//        result = String(format:"%04d", arc4random_uniform(10000) )
//    } while Set<Character>(result.characters).count < 6
//    return result
//}
extension Int {
    init(_ range: Range<Int> ) {
        let delta = range.lowerBound < 0 ? abs(range.lowerBound) : 0
        let min = UInt32(range.lowerBound + delta)
        let max = UInt32(range.upperBound   + delta)
        self.init(Int(min + arc4random_uniform(max - min)) - delta)
    }
}
extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
