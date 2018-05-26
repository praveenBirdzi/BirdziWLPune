//
//  Login.swift
//  Birdzi
//
//  Created by Dinesh Jagtap on 4/12/18.
//  Copyright © 2018 Birdzi. All rights reserved.
//

import UIKit
import TwitterKit
import SafariServices
import SVProgressHUD
import TTGSnackbar
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import GoogleSignIn
 class Login: UIViewController , UITextFieldDelegate,GIDSignInUIDelegate,GIDSignInDelegate{

    @IBOutlet weak var bgBlure: UIImageView!
    @IBOutlet weak var twitter: UIButton!
    let store = TWTRTwitter.sharedInstance().sessionStore
    var responseArray = NSMutableArray()
    var finalData = NSMutableDictionary()
    let facebookReadPermissions = ["public_profile", "email", "user_friends", "user_birthday", "user_location"]

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var logoImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bgBlure.blurImage(frame: self.logoImg.frame)
        GIDSignIn.sharedInstance().uiDelegate = self
        self.hideKeyboard()

       //        TWTRTwitter.sharedInstance().sessionStore.fetchGuestSession { (guestSession, error) in
//            if (guestSession != nil) {
//                // make API calls that do not require user auth
//            } else {
//                print("error: \(error)");
//            }
//        }
//               // Do any additional setup after loading the view.
//        twitter = TWTRLogInButton(logInCompletion: { session, error in
//            if (session != nil) {
//                print("signed in as \(session?.userName)");
//                let client = TWTRAPIClient.withCurrentUser()
//
//                client.requestEmail { email, error in
//                    if (email != nil) {
//                        print("signed in as \(session?.userName)");
//                    } else {
//                        print("error: \(error?.localizedDescription)");
//                    }
//                }
//            } else {
//                print("error: \(error?.localizedDescription)");
//            }
//        })
//        TWTRTwitter.sharedInstance().logIn {(session, error) in
//            if let s = session {
//                print("logged in user with id \(session?.userID)")
//            } else {
//                // log error
//            }
//        }
//        let store = TWTRTwitter.sharedInstance().sessionStore
//
//        if let userID = store.session()?.userID {
//            store.logOutUserID(userID)
//        }
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

    @IBAction func skipLogin(_ sender: UIButton) {
         let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! Home
         self.navigationController?.pushViewController(secondVC, animated: true)
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
                    UserDefaults.standard.set(true, forKey:"hasLogin")

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
                        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! Home
                        self.navigationController?.pushViewController(secondVC, animated: true)
                        UserDefaults.standard.set(true, forKey:"hasLogin")

                        
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
    func APICall() {
    SVProgressHUD.show()
    //DispatchQueue.global(qos: .userInitiated).async {
        
        let headers: HTTPHeaders = [
            "appkey": GlobalVariables.globalAppKey,
            "companyid" : GlobalVariables.globalCompanyId,
            "deviceid" : "020000000000",
            "email": self.emailTxt.text!
        ]
        APIUtilities.sharedInstance.getReqURL(getValidateEmailUrl, parameters: [:], headers: headers, completion:  {
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
                                    UserDefaults.standard.set(self.emailTxt.text!, forKey:"login_email")
                                    let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Password") as! Password
                                    secondVC.stringPassed = ""
                                    self.navigationController?.pushViewController(secondVC, animated: true)
                    }
                    else if(results.value(forKey: "status") as! Int == 44444)
                    {
                        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Password") as! Password
                        secondVC.stringPassed = self.emailTxt.text!
                        UserDefaults.standard.set(self.emailTxt.text!, forKey:"login_email")

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
        if(result?.isEmail)! {
            textField.resignFirstResponder();
            textField.textColor = UIColor(hexString: "#424B24")
          //  print("email is valid")
            self.APICall()
//            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Password") as! Password
//            secondVC.stringPassed = textField.text!
//            self.navigationController?.pushViewController(secondVC, animated: true)
            return true;

        } else {
            textField.becomeFirstResponder();
           // print("email is not valid")
            textField.textColor = .red
            return false;

        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        textField.textColor = UIColor(hexString: "#424B24")

        return true;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
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
extension UIImageView{
    func blurImage(frame: CGRect)
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect:blurEffect)
      //  questionFrame.frame = CGRectMake(0 , 0, self.view.frame.width, self.view.frame.height * 0.7)
        let height = frame.origin.y + frame.size.height / 2;
        let rect = CGRect(origin: CGPoint(x: -self.frame.width * 2,y :height), size: CGSize(width: self.frame.width * 6, height: self.frame.height ))

        blurEffectView.frame = rect
    //    blurEffectView.frame = self.bounds
        
       blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    func blurImageMenu(frame: CGRect)
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect:blurEffect)
         //  questionFrame.frame = CGRectMake(0 , 0, self.view.frame.width, self.view.frame.height * 0.7)
        let height = frame.origin.y + frame.size.height / 2;
        let rect = CGRect(origin: CGPoint(x: -self.frame.width * 2,y :height), size: CGSize(width: self.frame.width * 6, height: self.frame.height+60 ))
        
        blurEffectView.frame = rect
        //    blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    func blurImageNew(frame: CGRect)
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect:blurEffect)
        blurEffectView.backgroundColor = .white
        //  questionFrame.frame = CGRectMake(0 , 0, self.view.frame.width, self.view.frame.height * 0.7)
        let height = frame.origin.y + frame.size.height / 2;
        let rect = CGRect(origin: CGPoint(x: -self.frame.width * 2,y :height), size: CGSize(width: self.frame.width * 6, height: self.frame.height+60 ))
        
        blurEffectView.frame = rect
        //    blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}

import UIKit

@IBDesignable extension UIView {
    
    /* BORDER */
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
    }
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
}
}
extension String {
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
import UIKit

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
}
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
