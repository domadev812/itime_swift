//
//  LocationController.swift
//  iTime
//
//  Created by Димас on 7/11/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import CoreLocation
import UIKit

class LocationController: NSObject, CLLocationManagerDelegate {
 
    var manager:CLLocationManager
    var loc: Location?
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    override init() {
        manager = CLLocationManager()
        super.init()
        setup()
    }
    func setup() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        //manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        //manager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        
        let lat = 55.821028;// userLocation.coordinate.latitude
        let lon = 37.832538;//userLocation.coordinate.longitude
        
        //loc = Location(lat: "\(lat)", lon: "\(lon)")

        locCount += 1
        print("loccounts = \(locCount)")
        if locCount == 600 {
            locCount = 0
            print("from location controller")
            print("LONGITUDE: \(lon)      \nLATITUDE: \(lat)")
            
            //sendData()
            
            let id = NSUserDefaults.standardUserDefaults().integerForKey("user_id")
            if id == 0 {
                print("no id in data storage")
                return
            }
            print("id = \(id)")
            let date = NSDate().timeIntervalSince1970
            let timestamp = Int(date)
            let lat = "\(lat)"
            let lon = "\(lon)"

            
            
            
            if UIApplication.sharedApplication().applicationState == .Active {
                //mapView.showAnnotations(locations, animated: true)
                print("active mod count = \(locCount)")
                let params = [
                    "user_id": "\(id)",
                    "date": "\(timestamp)",
                    "lat": lat,
                    "lon": lon
                ]
                Manager.sharedInstance.tracker(params) { result in
                    if result {
                        print("sended from active state")
                    }
                }
            } else {
                print("App is backgrounded. Count = \(locCount)")
                let paramsToSend = ParamsForSend(user_id: "\(id)", timeStamp: "\(timestamp)", lat: lat, lon: lon)
                //Manager.backgroundFetchedLocations.append(paramsToSend)
                
                Manager.dataSaver.saveNewRecordInData(paramsToSend)
                
//                if let recordsInDefaults = userDefaults.valueForKey("records") {
//                    if var records = recordsInDefaults as? [ParamsForSend] {
//                        records.append(paramsToSend)
//                        userDefaults.synchronize()
//                    }
//                }
                
            }
        }
        
        
        
        
    }
    var locCount = 0
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print(error)
        
    }
    func startUpdating() {
        manager.startUpdatingLocation()
        locCount = 0
    }
    func stopUpdate() {
        manager.stopUpdatingLocation()
    }
    
    private func sendData() {
        print("starting collect information")
        let id = NSUserDefaults.standardUserDefaults().integerForKey("user_id")
        if id == 0 {
            print("no id in data storage")
            return
        }
        print("id = \(id)")
        let date = NSDate().timeIntervalSince1970
        let timestamp = Int(date)
        var params = [
            "user_id": "\(id)",
            "date": "\(timestamp)",
            "lat": "",
            "lon": ""
        ]
        if let loc = Manager.locationController.loc {
            params["lat"] = loc.lat
            params["lon"] = loc.lon
        }
        print("sending background api call")
        Manager.sharedInstance.tracker(params) { res in
        
        }
    }
}