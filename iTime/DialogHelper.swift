//
//  DialogHelper.swift
//  TAWASOUL
//
//  Created by Andrii on 6/6/16.
//  Copyright © 2016 Bohdan. All rights reserved.
//

import UIKit

class DialogHelper {
    
    static func showErrorAlert(error: String?, viewController: UIViewController) {
        showAlert(message: error, buttonTitles: ["Close"], actions: [nil], delegate: viewController)
    }
    
    static func showOkAlert(message: String?, title: String? = nil, viewController: UIViewController) {
        showAlert(title, message: message, buttonTitles: ["Ok"], actions: [nil], delegate: viewController)
    }
    
    static func showActionAlert(title: String?, message: String?, controller: UIViewController, action:() -> ()){
        let alert = UIAlertController(title: title, message:message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{_ in
            action()
        }))
        controller.presentViewController(alert, animated: true, completion: nil)
    }
    
    static func showAskAlert(title: String?, message: String? = nil, viewController: UIViewController, action: (Bool) -> Void ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { _ in
            action(true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .Default, handler: { _ in
            action(false)
        }))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    static func showAlert(title: String? = nil, message: String?, buttonTitles:[String], actions: [(() -> ())?], delegate: UIViewController) {
        MultiActionAlert(style: UIAlertControllerStyle.Alert, title: title, message: message, buttonTitles: buttonTitles, actions: actions, delegate: delegate).showAlert()
    }
    
    static func showSheet(title: String? = nil, message: String?, buttonTitles:[String], actions: [(() -> ())?], delegate: UIViewController) {
        MultiActionAlert(style: UIAlertControllerStyle.ActionSheet, title: title, message: message, buttonTitles: buttonTitles, actions: actions, delegate: delegate).showAlert()
    }
    
    static func shareUrl(urlString: String?, viewController: UIViewController) {
        if let urlString = urlString, url = NSURL(string: urlString) {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = viewController.view
            activityVC.popoverPresentationController?.sourceRect = CGRectMake(0, 0, 30, 30)
            viewController.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    static func handleErrorStringClosure() -> (String)->(){
        let presentedVC = UIApplication.sharedApplication().keyWindow?.rootViewController
        return {errStr in
            showErrorAlert(errStr, viewController: presentedVC!)
        }
    }
    
    static func showOkAlertOnPVC(message:String){
        if let presentedVC = UIApplication.sharedApplication().keyWindow?.rootViewController{
            showOkAlert(message, viewController: presentedVC)
        }
    }
    
    static func showAskAlertOnPVC(message: String, action: (Bool) -> Void) {
        if let presentedVC = UIApplication.sharedApplication().keyWindow?.rootViewController {
            showAskAlert(message, message: "", viewController: presentedVC, action: { (result) in
                action(result)
            })
        }
    }
    
    static func shareContent(text text: String?, image: UIImage?, controller: UIViewController){
        var itemsToShare = [AnyObject]()
        if let text = text {
            itemsToShare.append(text)
        }
        if let image = image {
            itemsToShare.append(image)
        }
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = activityCompletionHandler
        activityViewController.popoverPresentationController?.sourceView = controller.view
        activityViewController.popoverPresentationController?.sourceRect = CGRectMake(0, 0, 30, 30)
        controller.presentViewController(activityViewController, animated: true) { () -> Void in
            
            print("Sharing view did appear")
            
        }
    }
    
    static func activityCompletionHandler(activityType: String?, completed:Bool, returnedItems:[AnyObject]?, activityError:NSError?){
        if completed && activityError == nil{
            switch activityType!{
            case UIActivityTypeMail:print("activity finished for mail")
            case UIActivityTypeMessage:print("activity finished for message")
            case UIActivityTypePostToFacebook:print("activity finished for FB")
            case UIActivityTypePostToTwitter:print("activity finished for TWITTER")
            case UIActivityTypePostToFlickr:print("activity finished for Flickr")
            case UIActivityTypePostToVimeo:print("activity finished for Vimeo")
            case UIActivityTypePostToWeibo:print("activity finished for Weibo")
            default:print("activity finished with other type: \(activityType)")
            }
        }
    }
}

class MultiActionAlert {
    let style: UIAlertControllerStyle
    let title: String?
    let message: String?
    let buttonTitles:[String]
    let actions: [(() -> ())?]
    var delegate:UIViewController?
    let actionStyles:[UIAlertActionStyle]?
    
    init (style: UIAlertControllerStyle, title: String? = nil, message: String? = nil, buttonTitles:[String], actionStyles:[UIAlertActionStyle]? = nil, actions: [(() -> ())?], delegate: UIViewController) {
        self.style = style
        self.title = title
        self.message = message
        self.buttonTitles = buttonTitles
        self.actions = actions
        self.delegate = delegate
        self.actionStyles = actionStyles
    }
    
    func showAlert() {
        if let delegate = self.delegate {
            let alert = UIAlertController(title: self.title, message: self.message, preferredStyle: self.style)
            alert.popoverPresentationController?.sourceView = delegate.view
            alert.popoverPresentationController?.sourceRect = CGRectMake(0, 0, 30, 30)
            for x in 0..<buttonTitles.count {
                let buttonTitle = self.buttonTitles[x]
                let action =  self.actions[x]
                if let actionStyles = self.actionStyles{
                    let style = actionStyles[x]
                    alert.addAction(UIAlertAction(title: buttonTitle, style: style, handler: {_ in
                        action?()
                    }))
                } else {
                    alert.addAction(UIAlertAction(title: buttonTitle, style: .Default, handler: {_ in
                        action?()
                    }))
                }
            }
            delegate.presentViewController(alert, animated: true, completion: nil)
        }
    }
}

// iOS 9 BUG FIX
extension UIAlertController {
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    public override func shouldAutorotate() -> Bool {
        return false
    }
}