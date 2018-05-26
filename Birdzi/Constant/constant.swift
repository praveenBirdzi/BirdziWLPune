//
//  constant.swift
//  Birdzi
//
//  Created by Dinesh Jagtap on 4/18/18.
//  Copyright © 2018 Birdzi. All rights reserved.
//

import UIKit
let getBaseUrl = "https://apirbziapp-dev.birdzi.com/"
let getLoginUrl = getBaseUrl+"customers/login"
let getValidateEmailUrl =  getBaseUrl+"customers/checkEmailValidity"
let getRegisterUrl =  getBaseUrl+"customers/registercustomer"
let getForgotPassUrl =  getBaseUrl+"customers/resetpassword"
let getHomeUrl =  getBaseUrl+"beacon/dashboarddata"
let getLoyaltyValidateUrl =  getBaseUrl+"loyalty/validateloyaltyno"
let getVersionUrl =  getBaseUrl+"appresource/appversion"
let getStoreListWithZipUrl = getBaseUrl+"stores/liststoresaroundzip"
let setHomeStorUrl = getBaseUrl+"stores/sethomestore"

 
 struct GlobalVariables {
    
    static var globalString = "MyString"
    static var globalStoreName = "MyString"
    static var globalStoreAddress = "MyString"
    static var globalTimes = "MyString"
    static var globalOprationHr = "MyString"
    static var globalStoreImg = "MyString"
    static var globalISScolling = false
    static var globalISOffer = false
    static var globalcKey = ""
    static var globalAppKey = ""
    static var globalCompanyId = ""
    static var globalUDID = ""

  //  static var globalDeviceId = UIDevice.current.identifierForVendor?.uuidString
 //   "020000000000"
    static var globalDeviceId =  "020000000000"

}

struct GlobalVariablesArr {
    static var globalBannerArr:NSMutableArray = []
    static var globalProductArr:NSMutableArray = []
    static var globalRecipeArr:NSMutableArray = []
    static var globalBillboardArr:NSMutableArray = []
    static var globalListArr:NSMutableArray = []
    static var globalOfferArr:NSMutableArray = []
    static var globalActionArr:NSMutableArray = []
 
}
class constant: NSObject {
   
}
