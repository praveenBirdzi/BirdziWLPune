//
//  Password.swift
//  Birdzi
//
//  Created by Dinesh Jagtap on 4/16/18.
//  Copyright © 2018 Birdzi. All rights reserved.
//

import UIKit
import SVProgressHUD
import TTGSnackbar
import Alamofire
import TwitterKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class Password: UIViewController, UITextFieldDelegate,GIDSignInUIDelegate,GIDSignInDelegate {
    var stringPassed = ""
    @IBOutlet weak var bgBlure: UIImageView!
    @IBOutlet weak var msgLbl: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var twtButton: UIButton!
    @IBOutlet weak var gpluseButton: UIButton!
    @IBOutlet weak var iforgotBtn: UIButton!
    var isReset:Bool = false
    let facebookReadPermissions = ["public_profile", "email", "user_friends", "user_birthday", "user_location"]

     @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var passwordTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailLbl.text = stringPassed;
         GIDSignIn.sharedInstance().uiDelegate = self
        self.hideKeyboard()

        if(stringPassed != "" && !isReset)
        {
        self.msgLbl.text = "welcome back!"
            self.fbButton.isHidden = true
            self.twtButton.isHidden = true
            self.gpluseButton.isHidden = true
            self.iforgotBtn.setTitle("i forgot", for: .normal)
            self.iforgotBtn.underline()

        }
        else
        {
            self.msgLbl.text = ""
            if(isReset)
            {
                self.passwordTxt.placeholder = "create new password"

            }else
            {
                self.passwordTxt.placeholder = "create password"

            }
            self.iforgotBtn.setTitle("just visiting :)", for: .normal)
            self.iforgotBtn.underline()

            
        }
        self.iforgotBtn.setTitleColor(UIColor(hexString: "#424B24"), for: .normal)
          bgBlure.blurImage(frame: self.logoImg.frame)
        // Do any additional setup after loading the view.
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil{
            print(error ?? "some error")
            return
        }
        // lbl_name.text = user.profile.email
        print(user.profile.email)
        print(user.profile.imageURL(withDimension: 400))
        print(user.userID)
        print(user.authentication.idToken)
        print(user.profile.name)
        print(user.profile.givenName)
        print(user.profile.familyName)
        print(user.debugDescription)
        
        
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! Home
        self.navigationController?.pushViewController(secondVC, animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("TextField should return method called")
        if(isPasswordValid(textField.text!))
        {
            textField.resignFirstResponder();
            textField.textColor = UIColor(hexString: "#424B24")
            self.nextButton.isHidden = false
            if(stringPassed != "")
            {
                if(isReset)
                {
                    
                }
                else
                {
                self.LoginAPICall()
                }
            }
            else
            {
                UserDefaults.standard.set(self.passwordTxt.text!, forKey:"login_password")
                let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Register") as! Register
                 self.navigationController?.pushViewController(secondVC, animated: true)
            }
            
            return true;
            
        } else {
            textField.becomeFirstResponder();
            // print("email is not valid")
            textField.textColor = .red
            self.passwordView.isHidden = false
            return false;
            
        }
        
    }
    @IBAction func btnClick(sender: AnyObject) {
        (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
        if (sender as! UIButton).isSelected {
            passwordTxt.isSecureTextEntry = false
        } else {
            passwordTxt.isSecureTextEntry = true
        }
    }
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,12}")
        return passwordTest.evaluate(with: password)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        textField.textColor = UIColor(hexString: "#424B24")
        self.passwordView.isHidden = true
        if(isPasswordValid(textField.text!))
        {
              self.nextButton.isHidden = false
            //  print("email is valid")
//            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! Home
//            self.navigationController?.pushViewController(secondVC, animated: true)
//            return true;
            
        } else {
             // print("email is not valid")
             //self.passwordView.isHidden = false
 
        }
      // self.passwordView.isHidden = true

        return true;
    }
    @IBAction func fbLogin (_ sender: UIButton)
    {
        //  self.loginButtonClicked()
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["user_hometown","public_profile", "email", "user_birthday", "user_location","user_gender"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender, birthday,address,timezone,relationship_status,location{location}"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //   self.dict = result as! [String : AnyObject]
                    print(result!)
                    let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! Home
                    self.navigationController?.pushViewController(secondVC, animated: true)
                    // print(self.dict)
                }
            })
        }
    }
    
    
    
    @IBAction func googleLogin (_ sender: UIButton)
    {
        var error:NSError?
        
        //  GGLContext.sharedInstance().configureWithError(&error)
        
        if error != nil{
            print(error ?? "some error")
            return
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance().signIn()
    }
    private func signInWillDispatch(_ signIn: GIDSignIn!, error: NSError!) {
        // myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func twLogin (_ sender: UIButton)
    {
        
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                print("signed in as \(String(describing: session?.userName))");
                let client = TWTRAPIClient()
                let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/show.json"
                let params = ["id": session?.userID]
                var clientError : NSError?
                
                let request = client.urlRequest(withMethod: "GET", urlString: statusesShowEndpoint, parameters: params, error: &clientError)
                
                client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                    if connectionError != nil {
                        print("Error: \(connectionError)")
                    }
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: [])
                        print("json: \(json)")
                        UserDefaults.standard.set(true, forKey:"hasLogin")

                        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! Home
                        self.navigationController?.pushViewController(secondVC, animated: true)
                        
                    } catch let jsonError as NSError {
                        print("json error: \(jsonError.localizedDescription)")
                    }
                }
                //  TWTRAPIClient.
                //     print("signed in as \(String(describing:  .))");
                
            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        })
        
        
    }
    @IBAction func iforget(_ sender: UIButton) {
        if(stringPassed != "" && !isReset)
        {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "iForgot") as! iForgot
        secondVC.stringPassed = emailLbl.text!
        self.navigationController?.pushViewController(secondVC, animated: true)
        }
        else
        {
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! Home
            self.navigationController?.pushViewController(secondVC, animated: true)
        }
    }
    
    func LoginAPICall() {
        SVProgressHUD.show()
        //DispatchQueue.global(qos: .userInitiated).async {
        
        let headers: HTTPHeaders = [
            "appkey": GlobalVariables.globalAppKey,
            "companyid" : GlobalVariables.globalCompanyId,
            "deviceid" : "020000000000",
            "email": UserDefaults.standard.string(forKey: "login_email")!,
            "userpwd": self.passwordTxt.text!,
            "devicetypecode": "iphone",
            "devicetoken": "1",
            "advertisingidentifier": "B691A224-537E-46B0-A629-9F3D096F12DD",
            "locale": "ENGLISH"
        ]
  //      Birdzi@123
        print(NSLocale.current.languageCode)
        print(headers)
        APIUtilities.sharedInstance.getReqURL(getLoginUrl, parameters: [:], headers: headers, completion:  {
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
                                  if let details = (results.value(forKey: "data")) as? NSDictionary {
                                    UserDefaults.standard.set(details.value(forKey: "customerid") as! Int, forKey:"customerid")
                                      UserDefaults.standard.set(details.value(forKey: "customerdeviceid") as! Int, forKey:"customerdeviceid")
                                     UserDefaults.standard.set(details.value(forKey: "customersharedsecret") as! String, forKey:"customersharedsecret")
                                     UserDefaults.standard.set(details.value(forKey: "browsestoreId") as! Int, forKey:"browsestoreId")
                                     UserDefaults.standard.set(details.value(forKey: "zip") as! String, forKey:"zip")
                                    UserDefaults.standard.set(String(format:" %@ %@ ", details.value(forKey: "apptitle1") as! String, details.value(forKey: "apptitle2") as! String), forKey:"storeName")
 
                                    UserDefaults.standard.set(true, forKey:"hasLogin")
                                    
                                    let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! Home
                                    self.navigationController?.pushViewController(secondVC, animated: true)
                                }
                               
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
    
   
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func nextBtn(_ sender: UIButton) {
        if(stringPassed != "")
        {
            if(isReset)
            {
                
            }
            else
            {
                self.LoginAPICall()
            }
           // self.LoginAPICall()
        }
        else
        {
            UserDefaults.standard.set(self.passwordTxt.text!, forKey:"login_password")
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Register") as! Register
            self.navigationController?.pushViewController(secondVC, animated: true)
        }
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
            
extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
}
extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: text.count))
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
}


