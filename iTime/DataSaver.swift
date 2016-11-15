//
//  DataSaver.swift
//  iTime
//
//  Created by Димас on 7/18/16.
//  Copyright © 2016 Димас. All rights reserved.
//


class DataSaver: NSObject {
    
    //static let sharedInstance = DataSaver()

    internal var userDefaults = NSUserDefaults.standardUserDefaults()
    
    internal var recordsToSend = [ParamsForSend]()
    
    internal let key = "records"
    
    private func takeRecords(newParams: ParamsForSend) {
        if let dataObject = userDefaults.objectForKey(key) as? NSData {
            if let objectInDefaults = NSKeyedUnarchiver.unarchiveObjectWithData(dataObject) as? [ParamsForSend] {
                recordsToSend = objectInDefaults
                recordsToSend.append(newParams)
                userDefaults.setObject(recordsToSend, forKey: key)
                userDefaults.synchronize()
            }
            
        } else {
            var newObject = [ParamsForSend]()
            newObject.append(newParams)
            recordsToSend.append(newParams)
            let paramsData = NSKeyedArchiver.archivedDataWithRootObject(recordsToSend)
            userDefaults.setObject(paramsData, forKey: key)
            userDefaults.synchronize()
        }
    }
    
    func haveData() -> Bool {
        if userDefaults.objectForKey(key) != nil {
            return true
        } else {
            return false
        }
    }
    
    func saveNewRecordInData(newRecord: ParamsForSend) {
        takeRecords(newRecord)
    }
    
    func saveArrayOfData(newRecords: [ParamsForSend]) {
        for param in newRecords {
            takeRecords(param)
        }
    }
    
    func sendRecords(onComp: (Bool)->Void) {
        if let dataInDefaults = userDefaults.objectForKey(key) as? NSData {
            if let objectInDefaults = NSKeyedUnarchiver.unarchiveObjectWithData(dataInDefaults) as? [ParamsForSend] {

            recordsToSend = objectInDefaults
            if recordsToSend.isEmpty {
                print("records empty")
                onComp(false)
                return
            }
            var count = 0
            for (_,object) in recordsToSend.enumerate() {
                let params = [
                    "user_id": object.user_id,
                    "date": object.timeStamp,
                    "lat": object.lat,
                    "lon": object.lon
                ]
                Manager.sharedInstance.tracker(params) { result in
                    if result {
                        count += 1
                        if count == self.recordsToSend.count {
                            print("data removed and sended")
                            self.recordsToSend.removeAll()
                            let paramsData = NSKeyedArchiver.archivedDataWithRootObject(self.recordsToSend)
                            self.userDefaults.setObject(paramsData, forKey: self.key)
                            self.userDefaults.synchronize()
                            count = 0
                            onComp(true)
                        }
                    }
                }
                
                }}
        } else {
            onComp(false)
        }
    }
    
}
