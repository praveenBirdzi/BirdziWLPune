//
//  UserAPIManager.swift
//  Birdzi
//
//  Created by Nilam Mande on 5/29/18.
//  Copyright © 2018 Birdzi. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class UserAPIManager: NSObject {
    static let shared: UserAPIManager = UserAPIManager()
    typealias UserCompletionHandler = (_ responseObject: AnyObject?, _ success: Bool?, _ message : String?) -> Void

    var currentViewController : UIViewController?
    var userCompletionHandler: UserCompletionHandler?
    
    func callLoginAPI(_ headers :HTTPHeaders,  viewController : UIViewController,  myCompletionHandler: @escaping UserCompletionHandler) {
        
        self.userCompletionHandler = myCompletionHandler
        self.currentViewController = viewController
        
        SVProgressHUD.show()
        APIUtilities.sharedInstance.getReqURL(getValidateEmailUrl, parameters: [:], headers: headers, completion:  {
            (req, res, data)  -> Void in
            SVProgressHUD.dismiss()
            if(data.isSuccess) {
                if let results = (data.value as AnyObject) as? NSDictionary {            
                    if self.validateResponse(results) == true {
                        self.userCompletionHandler!(results, true, "")
                    } else {
                        self.userCompletionHandler!(results, false, "server error")
                    }
                }
            }  else if(data.isFailure) {
                let dataString = String(data: data.value as! Data, encoding: String.Encoding.utf8)
                self.userCompletionHandler!(nil, false, dataString)
            } else {
                self.userCompletionHandler!(nil, false, "server error")
            }
        })
    }
    
    func validateResponse(_ results : NSDictionary) -> Bool {
        if (results.value(forKey: "statusCode") as! Int != 0)
        {
            if (results.value(forKey: "status") as! Int != 0)
            {
                if (results.value(forKey: "status") as! Int == 22222) ||  (results.value(forKey: "status") as! Int == 44444) {
                    return true
                }
            }
        }
        return false
    }
}
