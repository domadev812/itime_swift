//
//  ServerManager.swift
//  iTime
//
//  Created by Димас on 6/9/16.
//  Copyright © 2016 Димас. All rights reserved.
// UIImageJPEGRepresentation(file as! UIImage, 0.5)

import Foundation
import ObjectMapper
import SwiftyJSON
import Alamofire
import UIKit


let mainControllerName = "MAIN_CONTROLLER"
let loginControllerName  = "LoginRegisterController"
let rootNavigationName = "rootNavigationController"
let startShiftTimeController = "startShiftTimeController"

enum Checkin {
    case Map, Selfie, QRCode, Clock
}
class Location {
    var lat: String
    var lon: String
    init (lat: String, lon: String) {
        self.lat = lat
        self.lon = lon
    }
}
class Manager {
    
    static let dataSaver = DataSaver()
    
    static let sharedInstance = Manager()
    static var registerParams = [
        "firstname": "",
        "lastname": "",
        "dob": "",
        "mob": "",
        "cscs": "",
        "cscsdate": "",
        "company": "555",
        "site": "1",
        "job": "",
        "email": "",
        "password": "",
        "type": "",
        "contractor": ""
    ]
    static var checkoutFlag = false
    static var registerPhoto = UIImage()
    static var user_id = 0
    static var user_token = ""
    static var avatar: UIImage?
    static var avatarLink: String?
    static var loginData: LoginData?
    static var checkinParams = [String: String]()
    static var location: Location?
    static var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    static let locationController = LocationController()
    static var img_report: UIImage!
    
    //static var backgroundFetchedLocations = [ParamsForSend]()
    
    let url = "http://52.30.177.101/api"
    
    //MARK: -  nsuserdefaults
    internal let kUserInUserDefaults = "user"
    func saveToUserDefaults(user: LoginData) {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(NSKeyedArchiver.archivedDataWithRootObject(user), forKey: kUserInUserDefaults)
        ud.synchronize()
    }
    func removeUserFromDefaults() {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.removeObjectForKey(kUserInUserDefaults)
        ud.synchronize()
    }
    
    //MARK: - md5
    func md5(string string: String) -> String {
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        return digestHex
    }
    
    //MARK: - registration
    func registration(controller: UIViewController, success: (Bool, Int) -> ()) {
        
        let imageData = UIImageJPEGRepresentation(Manager.registerPhoto, 0.5)
        
        Alamofire.upload(.POST, url + "/register.php", multipartFormData: {
            multipartFormData in
            multipartFormData.appendBodyPart(data: imageData!, name: "image", fileName: self.nameGenerator(15) + ".jpg", mimeType: "image/jpg")
            print("url : \(self.url)/register.php")
            for (key, value) in Manager.registerParams {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                print(" \(key) = \(value)")
                
            }
        }, encodingCompletion: { encodingResult in
        switch encodingResult {
            case .Success(let upload, _, _):
                print("success register")
                upload.responseJSON { response in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.result)   // result of response serialization
                    
                    if let body = response.result.value {
                        print("JSON: \(body)")
                        let data = JSON(body)
                        let status = data["status"].intValue;
                        if status == 1 {
                            if let id = data["data"]["user_id"].int {
                                success(true, id)
                            }
                        }
                        
                    } else {
                        success(false, 0)
                    }
                }
            
            case .Failure(let encodingError):
                print(encodingError)
                success(false, 0)
            }
        })
        
    }
    
    func checkNumber(controller: UIViewController, phone: String, onCompletion: (Bool) -> Void ) {
        let params = ["mob": phone]
        print("params = \(params)")
        
        Alamofire.request(.POST, url + "/checkphone", parameters: params).responseJSON { (response) in
            print(response.result)
            print(response.response)
            print(response.request)
            if response.result.value != nil {
                let data = JSON(response.result.value!)
                print("data = \(data)")
                onCompletion(data.bool!)
            }
        }
    }
    //MARK: - update user
    func updateUser(controller: UIViewController, success: (Bool, String) -> ()) {
        
        let imageData = UIImageJPEGRepresentation(Manager.registerPhoto, 0.5)
        
        Alamofire.upload(.POST, url + "/updateuser.php", multipartFormData: {
            multipartFormData in
            multipartFormData.appendBodyPart(data: imageData!, name: "image", fileName: self.nameGenerator(15) + ".jpg", mimeType: "image/jpg")
            print("url : \(self.url)/updateuser.php")
            for (key, value) in Manager.registerParams {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                print(" \(key) = \(value)")
                
            }
            multipartFormData.appendBodyPart(data: String(Manager.user_id).dataUsingEncoding(NSUTF8StringEncoding)!, name: "user_id")
        }, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    print("success update User Info")
                    upload.responseJSON { response in
                        print(response.request)  // original URL request
                        print(response.response) // URL response
                        print(response.result)   // result of response serialization
                        
                        if let body = response.result.value {
                            print("JSON: \(body)")
                            let data = JSON(body)
                            let status = data["status"].intValue;
                            let message = data["message"].string
                            if status == 1 {
                                success(true, "Your Account Info is changed!")
                            }
                            success(false, message!)
                        } else {
                            success(false, "Server Error!")
                        }
                    }
                    
                case .Failure(let encodingError):
                    print(encodingError)
                    success(false, "Server Error!")
                }
        })
        
    }
    
    //MARK: - login
    func login(controller: BaseViewController, params: [String: AnyObject], result: (AnyObject)->()) {
        print("try log")
        print("params = \(params)")
        Alamofire.request(.POST, url + "/login.php", parameters: params).responseJSON { (response) in
            print("POST-----------------------------login")
                print("path = \(self.url)/login")
                print("params = \(params)")
                print("response.result = \(response.result)")
                print("response.response = \(response.response)")
                if response.result.value != nil {
                    result(true)
                    let post = JSON(response.result.value!)
                    
                    let status = post["status"].intValue;
                    if status == 1 {
                        let data = LoginData(json: post["data"])
                        Manager.loginData = data
                        
                        self.saveToUserDefaults(data)
                        
                        if let id: Int = data.internalIdentifier {
                            Manager.userDefaults.setInteger(id, forKey: "user_id")
                            Manager.userDefaults.synchronize()
                        }
                        if data.image != nil {
                            Manager.avatarLink = data.image
                        }
                        result(data)
                    } else {
                        if let message = post["message"].string {
                            controller.displayAlert("Error!", error: message)
                        }
                    }
                    print("post data = \(post)")
                } else {
                    controller.hideActivity()
                    controller.displayAlert("Error", error: "Try again")
                    print("No body in post")
                }
            print("POST LOGIN--------------------------END")
        }
    }
    
    //MARK: - checkins
    func checkin(controller: UIViewController, type: Checkin, params: [String: AnyObject], selfie: UIImage?, result: (Bool) -> ()) {
        switch type {
        case .Map:
            Alamofire.request(.POST, url + "/checkinlocation", parameters: params).responseJSON { (response) in
                print("path = \(self.url)/checkinlocation")
                print("params = \(params)")
                print("response.result = \(response.result)")
                print("response.response = \(response.response)")
                if response.result.value != nil {
                    
                    result(true)
                    let post = JSON(response.result.value!)
                    print("post data = \(post)")
                } else {
                    print("No body in post")
                }
                print("POST MAP--------------------------END")
            }
            
            break
        case .QRCode:
            Alamofire.request(.POST, url + "/checkinqr", parameters: params).responseJSON { (response) in
                print("path = \(self.url)/checkinqr")
                print("params = \(params)")
                print("response.result = \(response.result)")
                print("response.response = \(response.response)")
                if response.result.value != nil {
                    
                    result(true)
                    let post = JSON(response.result.value!)
                    print("post data = \(post)")
                } else {
                    print("No body in post")
                }
                print("POST QR--------------------------END")
            }
            break
        case .Selfie:
            let imageData = UIImageJPEGRepresentation(selfie!, 0.5)
            
            Alamofire.upload(.POST, url + "/checkinselfy", multipartFormData: {
                multipartFormData in
                multipartFormData.appendBodyPart(data: imageData!, name: "file", fileName: self.nameGenerator(15) + ".jpg", mimeType: "image/jpg")
                for (key, value) in params {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                }
                }, encodingCompletion: {
                    encodingResult in
                    
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        print("s")
                        result(true)
                        upload.responseJSON { response in
                            print(response.request)  // original URL request
                            print(response.response) // URL response
                            print(response.result)   // result of response serialization
                            
                            if let JSON = response.result.value {
                                print("JSON: \(JSON)")
                            }
                        }
                        
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
            })

        default: break
        }
    }
    
    func checkin(controller: UIViewController, selfie: UIImage?, onComp: (Bool) -> Void) {
        let date = NSDate().timeIntervalSince1970
        Manager.checkinParams["date"] = "\(Int(date))"
        var paramsToSend: [String: String] = [
            "user_id": "\(Manager.user_id)",
            "date": Manager.checkinParams["date"] != nil ? "\(Manager.checkinParams["date"]!)" : "",
            "qr": Manager.checkinParams["qr"] != nil ? "\(Manager.checkinParams["qr"]!)" : "",
            "lat": Manager.checkinParams["lat"] != nil ? "\(Manager.checkinParams["lat"]!)" : "",
            "lon": Manager.checkinParams["lon"] != nil ? "\(Manager.checkinParams["lon"]!)" : ""
        ]
        print("parms to send = \(paramsToSend)")
        
        if selfie != nil {
            let imageData = UIImageJPEGRepresentation(selfie!, 0.5)
            paramsToSend["qr"] = ""
//            let paramsWithPhoto = [
//            "user_id": paramsToSend["user_id"],
//            "date": paramsToSend["date"]
//            ]
            print("newParamsToSend = \(paramsToSend)")
            Alamofire.upload(.POST, url + "/checkin.php", multipartFormData: {
                multipartFormData in
                multipartFormData.appendBodyPart(data: imageData!, name: "image", fileName: self.nameGenerator(15) + ".jpg", mimeType: "image/jpg")
                for (key, value) in paramsToSend {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                }
                }, encodingCompletion: {
                    encodingResult in
                    
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        print("encoding success")
                        upload.responseJSON { response in
                            print(response.request)  // original URL request
                            print(response.response) // URL response
                            print(response.result)   // result of response serialization
                            onComp(true)
                            if let JSON = response.result.value {
                                print("checkin with photo: \(JSON)")
                                //Manager.checkinParams.removeAll()
                            }
                        }
                        
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
            })

        } else {
            Alamofire.request(.POST, url + "/checkin", parameters: paramsToSend).responseJSON { (response) in
                print("path = \(self.url)/checkin")
                print("params = \(paramsToSend)")
                print("response.result = \(response.result)")
                print("response.response = \(response.response)")
                if response.result.value != nil {
                    
                    onComp(true)
                    let post = JSON(response.result.value!)
                    //Manager.checkinParams.removeAll()
                    print("checkin no photo: \(post)")
                } else {
                    print("No body in post")
                }
            }
        }
    }
    
    //MARK: - checkout
    func checkout_origin(controller: UIViewController, onComp: (Bool)->Void) {
        
        let date = NSDate().timeIntervalSince1970
        let total = Int(date) - Int(Manager.checkinParams["date"]!)!
        let params = [
        "user_id": "\(Manager.user_id)",
        "date": "\(Int(date))",
        "total":"\(total)"
        ]
        
        Alamofire.request(.POST, url + "/checkout.php", parameters: params).responseJSON { (response) in
            print("path = \(self.url)/checkout")
            print("params = \(params)")
            print("response.result = \(response.result)")
            print("response.response = \(response.response)")
            if response.result.value != nil {
                
                let post = JSON(response.result.value!)
                if let status = post["status"].int {
                    if status == 1 {
                        onComp(true)
                    } else {
                        onComp(false)
                    }
                }
                print("checkout = \(post)")
            } else {
                print("No body in post")
            }
        }
    }
    func checkout(controller: UIViewController, onComp: (Bool) -> Void) {
        let date = NSDate().timeIntervalSince1970
        Manager.checkinParams["date"] = "\(Int(date))"
        let paramsToSend: [String: String] = [
            "user_id": "\(Manager.user_id)",
            "date": Manager.checkinParams["date"] != nil ? "\(Manager.checkinParams["date"]!)" : "",
            "qr": Manager.checkinParams["qr"] != nil ? "\(Manager.checkinParams["qr"]!)" : "",
            "lat": Manager.checkinParams["lat"] != nil ? "\(Manager.checkinParams["lat"]!)" : "",
            "lon": Manager.checkinParams["lon"] != nil ? "\(Manager.checkinParams["lon"]!)" : ""
        ]
        print("parms to send = \(paramsToSend)")
        Alamofire.request(.POST, url + "/checkout.php", parameters: paramsToSend).responseJSON { (response) in
            print("path = \(self.url)/checkout.php")
            print("params = \(paramsToSend)")
            print("response.result = \(response.result)")
            print("response.response = \(response.response)")
            if response.result.value != nil {
                
                onComp(true)
                let post = JSON(response.result.value!)
                //Manager.checkinParams.removeAll()
                print("checkin no photo: \(post)")
            } else {
                print("No body in post")
            }
        }
    }
    //MARK: - cheating
    func cheating() {
        let date = NSDate().timeIntervalSince1970
        let timestamp = Int(date)
        let userID = Manager.user_id
        let params = [
        "user_id": "\(userID)",
        "date": "\(timestamp)",
        "warning": "0"
        ]
        Alamofire.request(.POST, url + "/cheating", parameters: params).responseJSON { (response) in
            print("path = \(self.url)/cheating")
            print("params = \(params)")
            print("response.result = \(response.result)")
            print("response.response = \(response.response)")
            if response.result.value != nil {
                let post = JSON(response.result.value!)
                print("checkout = \(post)")
            } else {
                print("No body in post")
            }

        }
    }
    //MARK: - background senderOr saver
    func tracker(params: [String: String], onComp:(Bool)->Void) {
        
        Alamofire.request(.POST, url + "/position", parameters: params).responseJSON { (response) in
            onComp(true)
            print("path = \(self.url)/position")
            print("params = \(params)")
            print("response.result = \(response.result)")
            print("response.response.statucCode = \(response.response?.statusCode)")
            if response.result.value != nil {
                let post = JSON(response.result.value!)
                print("background post call sended\ndata = \(post)")
            } else {
                print("Save to local data")
            }
        }
    }
    //MARK: - Report incident
    func reportIncident(params: String, onComp:(Bool)->Void) {
        let param = [
            "user_id" : Manager.user_id,
            "site_id" : 1,
            "description" : params
        ]
        let imageData = UIImageJPEGRepresentation(Manager.img_report, 0.5)
        Alamofire.upload(.POST, url + "/incident.php", multipartFormData: {
            multipartFormData in
            multipartFormData.appendBodyPart(data: imageData!, name: "photo", fileName: self.nameGenerator(15) + ".jpg", mimeType: "image/jpg")
            for (key, value) in param {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key as! String)
            }
            }, encodingCompletion: {
                encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    print("encoding success")
                    upload.responseJSON { response in
                        print(response.request)  // original URL request
                        print(response.response) // URL response
                        print(response.result)   // result of response serialization
                        onComp(true)
                        if let JSON = response.result.value {
                            print("checkin with photo: \(JSON)")
                            //Manager.checkinParams.removeAll()
                        }
                    }
                    
                case .Failure(let encodingError):
                    print(encodingError)
                    onComp(false)
                }
        })
    }
    //MARK: - reset password
    func resetPassword(param: String, onComp: (Int, String)->Void) {
        Alamofire.request(.POST, url + "/resetpassword.php", parameters: ["email": "\(param)"]).responseJSON { (response) in
            if let body = response.result.value {
                print("JSON: \(body)")
                let data = JSON(body)
                let status = data["status"].intValue
                let message = data["message"].string
                if status == 1 {
                   onComp(1, message!)
                }else {
                    onComp(2, message!)
                }
            } else {
                onComp(3, "System Error!")
            }
        }
    }

    //MARK: - get Documents
    func getDocuments(onComp: (Bool, AnyObject)->Void) {
        Alamofire.request(.POST, url + "/documents.php", parameters: ["user_id": "\(Manager.user_id)"]).responseJSON { (response) in
            if let body = response.result.value {
                print("JSON: \(body)")
                let data = JSON(body)
                let status = data["status"].intValue
                if status == 1 {
                    let model = DocumentModel(json: data)
                    onComp(true, model)
                }else {
                    onComp(false, "")
                }
            } else {
                onComp(false, "")
            }
        }
    }

    //MARK: - get check in/out data
    func getCheckData(onComp: (Bool, AnyObject)->Void) {
        Alamofire.request(.POST, url + "/getcheckinout.php", parameters: ["user_id": "\(Manager.user_id)"]).responseJSON { (response) in
            if let body = response.result.value {
                print("JSON: \(body)")
                let data = JSON(body)
                let status = data["status"].intValue
                if status == 1 {
                    let model = DocumentModel(json: data)
                    onComp(true, model)
                }else {
                    onComp(false, "")
                }
            } else {
                onComp(false, "")
            }
        }
    }
    
    //MARK: - calendar total
    func calendarTotal(controller: UIViewController, onComp: (ColorCalendarModel)->Void) {
        Alamofire.request(.POST, url + "/calendar_total", parameters: ["user_id": "\(Manager.user_id)"]).responseJSON { (response) in
            print("path = \(self.url)/calendar_total")
            print("params = [\"user_id\": \(Manager.user_id)]")
            print("response.result = \(response.result)")
            print("response.response.statusCode = \(response.response?.statusCode)")
            if response.result.value != nil {
//                let post = JSON(response.result.value!)
//                let model = ColorCalendarModel(json: post)
//                if let date = model.data![0].date {
//                    let calendardate = NSDate(timeIntervalSince1970: Double(date))
//                    print("some date = \(calendardate)")
//                    onComp(model)
//                }
//                print("data calendar colors = \(post)")
            } else {
                print("no body")
            }
        }
    }
    //MARK: - get shifts
    func getShifts(controller: UIViewController, onComp: (Int, Int, Int, AnyObject)->()) {
        Alamofire.request(.POST, url + "/shifts.php", parameters: ["user_id": "\(Manager.user_id)"]).responseJSON { (response) in
            print("path = \(self.url)/shifts.php")
            print("params = [\"user_id\": \(Manager.user_id)]")
            print("response.result = \(response.result)")
            print("response.response.statusCode = \(response.response?.statusCode)")
//            if response.result.value != nil {
//                let post = JSON(response.result.value!)
//                let model = ColorCalendarModel(json: post)
//                if let date = model.data![0].date {
//                    let calendardate = NSDate(timeIntervalSince1970: Double(date))
//                    print("some date = \(calendardate)")
//                    onComp(model)
//                }
//                print("data calendar colors = \(post)")
//            } else {
//                print("no body")
//            }
            var model: ColorCalendarModel!
            if let body = response.result.value {
                print("JSON: \(body)")
                let data = JSON(body)
                let status = data["status"].intValue
                if status == 1 {
                    model = ColorCalendarModel(json: data)
                    let uc = data["upcoming"].intValue
                    let pc = data["past"].intValue
                    onComp(1,uc,pc,model)
                }else {
                    onComp(0,0,0, "")
                }
            } else {
                onComp(0,0,0, "")
            }
        }
    }
    
    //MARK: - get times for some day
    func getTimeForDate(date: Int, onComp: (DayDatas) -> Void ) {
        let params = [
        "user_id": "\(Manager.user_id)",
        "date": "\(date)"
        ]
        Alamofire.request(.POST, url + "/calendar_day", parameters: params).responseJSON { (response) in
            print("path = \(self.url)/calendar_day")
            print("params = \(params)")
            print("response.result = \(response.result)")
            print("response.response.statucCode = \(response.response?.statusCode)")
            if response.result.value != nil {
                let post = JSON(response.result.value!)
                print("data calendar_day = \(post)")
                let dataobject = DayDatas(json: post)
                onComp(dataobject)
            } else {
                print("no body")
            }

        }
    }
    
    //MARK: - namegen
    private func nameGenerator(currentPicker: Int) -> String {
        let lowercaseSymb: NSString = "abcdefghijklmnopqrstuvwxyz"
        let uppercaseSymb: NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let numbersSymb: NSString = "0123456789"
        
        let letters:NSString = (lowercaseSymb as String) + (uppercaseSymb as String) + (numbersSymb as String)
        
        let randomString  = NSMutableString(capacity: currentPicker)
        
        for _ in 0..<currentPicker {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        let fileName = (randomString as String)
        print("file_name = \(fileName)")
        return fileName
    }
}