//
//  storeModel.swift
//  Birdzi
//
//  Created by Dinesh Jagtap on 5/25/18.
//  Copyright © 2018 Birdzi. All rights reserved.
//


import Foundation
struct storeModel {
    let storeid: Int
    let locationid: Int
    let storecode: String
    let name: String
   // let address1: String
   // let address2: String
    let apptitle1: String
    let apptitle2: String
    //let city: String
    //let stateprovinceid: Int
   // let zip: String
    let phone: String
   // let fax: String
   // let email: String
   // let wifi: Bool
   // let storemap: String
    let latitude: Double
    let longitude: Double
  //  let geofenceradius: Double
  //  let granularity: Int
  //  let groundfloorid: Int
    let storehours: String
 //   let timezone: String
  //  let stateprovincename: String
    let isHomeStore: Bool
    let isBrowseStore: Bool
    let distance: Double
  //  let storeaisleavailable: Bool
  //  let storeversion: String
  //  let homeStoreIntercomName: String
//    let browseStoreIntercomName: String
//    let homeStoreCode: Int
  //  let browseStoreCode: Int
    init?(dict: [String: Any]) {
        guard let storeid = dict["storeid"] as? Int,
            let locationid = dict["locationid"] as? Int,
            let storecode = dict["storecode"] as? String,
            let name = dict["name"] as? String,
             let apptitle1 = dict["apptitle1"] as? String,
            let apptitle2 = dict["apptitle2"] as? String,
        let latitude = dict["latitude"] as? Double,
        let longitude = dict["longitude"] as? Double,
        let distance = dict["distance"] as? Double,
        let storehours = dict["storehours"] as? String,
        let phone = dict["phone"] as? String,
        let isHomeStore = dict["isHomeStore"] as? Bool,
        let isBrowseStore = dict["isBrowseStore"] as? Bool
            else { return nil }
        
        self.storeid = storeid
        self.locationid = locationid
        self.storecode = storecode
        self.name = name
        self.apptitle1 = apptitle1
        self.apptitle2 = apptitle2
        self.latitude = latitude
        self.longitude = longitude
        self.distance = distance
        self.storehours = storehours
        self.phone = phone
        self.isHomeStore = isHomeStore
        self.isBrowseStore = isBrowseStore
    }
}
