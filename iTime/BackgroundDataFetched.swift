//
//  BackgroundDataFetched.swift
//  iTime
//
//  Created by Димас on 7/11/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import Foundation

class ParamsForSend: NSObject {
    var user_id: String
    var timeStamp: String
    var lat: String
    var lon: String
    
    internal let kUser_id: String = "kUser_id"
    internal let kTimeStamp = "kTimeStamp"
    internal let kLat = "kLat"
    internal let kLon = "kLon"
    
    init(user_id: String, timeStamp: String, lat: String, lon: String) {
        self.user_id = user_id
        self.timeStamp = timeStamp
        self.lat = lat
        self.lon = lon
    }
    
    // MARK: NSCoding Protocol
    required internal init(coder aDecoder: NSCoder) {
        self.user_id = aDecoder.decodeObjectForKey(kUser_id) as! String
        self.timeStamp = aDecoder.decodeObjectForKey(kTimeStamp) as! String
        self.lat = aDecoder.decodeObjectForKey(kLat) as! String
        self.lon = aDecoder.decodeObjectForKey(kLon) as! String
        
    }
    
    internal func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(user_id, forKey: kUser_id)
        aCoder.encodeObject(timeStamp, forKey: kTimeStamp)
        aCoder.encodeObject(lat, forKey: kLat)
        aCoder.encodeObject(lon, forKey: kLon)
    }
    
    
}