//
//  AppDelegate.swift
//  Birdzi
//
//  Created by Dinesh Jagtap on 4/12/18.
//  Copyright © 2018 Birdzi. All rights reserved.
//

import UIKit
import HockeySDK
import TwitterKit
import AVKit
import FBSDKLoginKit
import GoogleSignIn
import GoogleMaps
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate{
    var details : NSDictionary = [:]
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
//            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let fullName = user.profile.name
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
//            let email = user.profile.email
            // ...
        }
    }
    

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.APICall()

        UserDefaults.standard.set("home", forKey: "SelectedMenu")
        UserDefaults.standard.set(false, forKey: "isHomeSet")
        UserDefaults.standard.set("", forKey: "UUID")
        UserDefaults.standard.set("", forKey: "customerid")
        UserDefaults.standard.set("", forKey: "customersharedsecret")
        
        TWTRTwitter.sharedInstance().start(withConsumerKey: "hZWixCs9oYXFeVVZNvC0xHx0P", consumerSecret:"folaPIdbkrVYlLl2zfesoE6aPb6yXiFpEDE4RjYzj1cv42CgpH")
        GIDSignIn.sharedInstance().delegate = self as GIDSignInDelegate
        GIDSignIn.sharedInstance().clientID = "28277024700-099cnjqlihreav1n8ot9tl4gb2gnodl2.apps.googleusercontent.com"
        GMSServices.provideAPIKey("AIzaSyAoIQ6cRCpR9VAwry4GhIgg1HnCxCBppYo")

        let defaults = UserDefaults.standard;
        if defaults.array(forKey: "listArr") != nil{
            let tempList : NSArray = defaults.array(forKey: "listArr")! as NSArray

            GlobalVariablesArr.globalListArr = tempList.mutableCopy() as! NSMutableArray
             //   key as! NSMutableArray
                
            }
        if defaults.array(forKey: "offer_arr") != nil{
            let tempList : NSArray = defaults.array(forKey: "offer_arr")! as NSArray
            
            GlobalVariablesArr.globalOfferArr = tempList.mutableCopy() as! NSMutableArray
            //   key as! NSMutableArray
            
        }
       FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
      
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    func APICall() {
        if let path = Bundle.main.path(forResource: "config_full", ofType: "json") {
            do {
                
                if let jsonData = NSData(contentsOfFile: path)
                {
                    
                    let jsonResult = try! JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    //  if let results = (data as AnyObject) as? NSDictionary {
                    print(jsonResult)
                    print ("\(jsonResult) results found")
                    UserDefaults.standard.set(jsonResult.value(forKey: "isLoyalty") as! Bool, forKey:"isLoyalty")
                    UserDefaults.standard.set(jsonResult.value(forKey: "isLoading") as! Bool, forKey:"isLoading")
                    UserDefaults.standard.set(jsonResult.value(forKey: "socialEnabled") as! Bool, forKey:"socialEnabled")
                    UserDefaults.standard.set(jsonResult.value(forKey: "vendorFooter") as! Bool, forKey:"vendorFooter")
                    UserDefaults.standard.set(jsonResult.value(forKey: "cID") as! String, forKey:"cID")
                    UserDefaults.standard.set(jsonResult.value(forKey: "appKey") as! String, forKey:"appKey")
                    UserDefaults.standard.set(jsonResult.value(forKey: "ckey") as! String, forKey:"ckey")
                    GlobalVariables.globalcKey = jsonResult.value(forKey: "ckey") as! String
                    GlobalVariables.globalAppKey = jsonResult.value(forKey: "appKey") as! String
                    GlobalVariables.globalCompanyId = jsonResult.value(forKey: "cID") as! String
                     if let detail = (jsonResult.value(forKey: "APIKey")) as? NSDictionary {
                        self.details = detail
                        BITHockeyManager.shared().start()
                        BITHockeyManager.shared().configure(withIdentifier: details.value(forKey: "Hockey") as! String)
                    }
                   
               
                    if (jsonResult.value(forKey: "isLoyalty") as! Bool)
                    {
                        print("Loylty")
                    }
                    if (jsonResult.value(forKey: "isLoading") as! Bool)
                    {
                        print("Loading")
                    }
                    
                    //  }
                }
            } catch {
                print(error.localizedDescription)
                // handle error
            }
        }
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url);
        print(url.absoluteString)
                    let fullNameArr = url.absoluteString.components(separatedBy: ":")
                    print(fullNameArr)
                    let app_name    = fullNameArr[0]
                    if(app_name == "birdziapp")
                    {
                    let action_name = fullNameArr[1]
                    let action_base_url =  fullNameArr[3]
                    let action_url =  fullNameArr[4]
        
        
                        if(action_name == "playvideo")
                        {
                            let urlStr = String(format:"%@:%@",action_base_url,action_url)
                            let videoURL = NSURL(string: urlStr)
        
        //                    if let url =  NSURL(string: urlStr){
        //                        UIApplication.shared.openURL(url as URL)
        //                    }
                            let currentController = UIApplication.topViewController()
        
                            let video = AVPlayer(url: videoURL! as URL)
                            let videoPlayer = AVPlayerViewController()
                            videoPlayer.player = video
                            currentController?.present(videoPlayer, animated: true, completion:
                                {
                                    video.play()
                            })
        
                        }
                        if(action_name == "launchurl")
                        {
                            let urlStr = String(format:"%@:%@",action_base_url,action_url)
        
                            if let url =  NSURL(string: urlStr){
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.openURL(url as URL)
                                }
                           //     UIApplication.shared.openURL(url as URL)
                            }
        
                        }
                        if(action_name == "product_detail")
                        {
                            let urlStr = String(format:"%@:%@",action_base_url,action_url)
 
                            let currentController = UIApplication.topViewController()
                            let secondVC = currentController?.storyboard?.instantiateViewController(withIdentifier: "productDetailVC") as! productDetailVC
                             secondVC.titleTxt = "Offer Detail Screen"

                            currentController?.navigationController?.pushViewController(secondVC, animated: true)
        
        //                    currentController?.navigationController!.view.layer.add(transition, forKey: kCATransition)
        //                    currentController?.present(productDetailVC(), animated: false, completion: nil)
        
                        }
                    }
 
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options) || GIDSignIn.sharedInstance().handle(url,sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge]) //required to show notification when in foreground
    }
    
}

