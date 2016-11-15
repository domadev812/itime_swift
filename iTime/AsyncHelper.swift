//
//  AsyncHelper.swift
//  TAWASOUL
//
//  Created by Andrii on 6/7/16.
//  Copyright © 2016 Bohdan. All rights reserved.
//

import UIKit

class AsyncHelper {
    
    static func runAsync(operation: () -> (), finishCallback: (() -> ())? = nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            operation()
            if let finishCallback = finishCallback {
                dispatch_async(dispatch_get_main_queue()) {
                    finishCallback()
                }
            }
        }
    }
    
    static func runAsync<T>(operation: () -> (T), finishCallback: (T) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            let result = operation()
            dispatch_async(dispatch_get_main_queue()) {
                finishCallback(result)
            }
        }
    }
    
    static func delay(time: Double, operation: () -> ()) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            operation()
        }
    }
    
    static func runInBackgrund<T>(operation: () -> (T), finishCallback: (T) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let result = operation()
            dispatch_async(dispatch_get_main_queue()) {
                finishCallback(result)
            }
        }
    }
    
    static func runAsync(operation: () -> (), finishCallback: () -> (), container: UIView) {
        let activityIndicator = AsyncHelper.createAndShowActivityIndicator(container)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            operation()
            dispatch_async(dispatch_get_main_queue()) {
                finishCallback()
                AsyncHelper.removeActivityIndicator(activityIndicator)
            }
        }
    }
    
    static func runOnMainQueue(operation: () -> ()) {
        dispatch_async(dispatch_get_main_queue()) {
            operation()
        }
    }
    
    static let activityIndicatorSize = CGFloat(50), loadingViewSize = CGFloat(90)
    static let doneViewImageSize = CGFloat(80), doneViewSize = CGFloat(100)
    static let activityIndicatorAnimationDuration:Double = 0.1
    static let customActivityIndicatorFolder = "activity-indicator", customActivityIndicatorFileFormat = "img"
    
    static func createAndShowActivityIndicator(uiView: UIView) -> UIView {
        let loadingView: UIView = UIView()
        loadingView.frame = CGRectMake(0, 0, loadingViewSize, loadingViewSize)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.97)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let customActivityIndicatorFilePath = NSBundle.mainBundle().pathForResource(customActivityIndicatorFileFormat + "1", ofType: "png", inDirectory: customActivityIndicatorFolder)
        if let path = customActivityIndicatorFilePath where NSFileManager.defaultManager().fileExistsAtPath(path) {
            let activityIndicator = UIImageView(frame: CGRectMake(0.0, 0.0, activityIndicatorSize, activityIndicatorSize))
            activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2)
            activityIndicator.image = UIImage.animatedImageNamed(customActivityIndicatorFolder + "/" + customActivityIndicatorFileFormat, duration: activityIndicatorAnimationDuration)
            loadingView.addSubview(activityIndicator)
        } else {
            let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
            activityIndicator.frame = CGRectMake(0.0, 0.0, activityIndicatorSize, activityIndicatorSize)
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
            activityIndicator.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2)
            activityIndicator.startAnimating()
            loadingView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.75)
            loadingView.addSubview(activityIndicator)
        }
        uiView.addSubview(loadingView)
        
        // Make progress bar constraints
        let horizontalConstraint = NSLayoutConstraint(item: loadingView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: uiView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        uiView.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: loadingView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: uiView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        uiView.addConstraint(verticalConstraint)
        
        let widthConstraint = NSLayoutConstraint(item: loadingView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: loadingViewSize)
        uiView.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: loadingView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: loadingViewSize)
        uiView.addConstraint(heightConstraint)
        
        return loadingView
    }
    
    static func showDoneView(viewController: UIViewController, onFinishAnimation: () -> ()) {
        if let uiView = viewController.navigationController?.view {
            let transparentView: UIView = UIView()
            transparentView.frame = uiView.frame
            transparentView.center = uiView.center
            transparentView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.59)
            
            let loadingView: UIView = UIView()
            loadingView.frame = CGRectMake(0, 0, doneViewSize, doneViewSize)
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)
            loadingView.clipsToBounds = true
            loadingView.layer.cornerRadius = 7
            
            let actInd = UIImageView()
            actInd.frame = CGRectMake(0.0, 0.0, doneViewImageSize, doneViewImageSize)
            actInd.image = UIImage(named: "done")
            actInd.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2)
            loadingView.addSubview(actInd)
            transparentView.addSubview(loadingView)
            uiView.addSubview(transparentView)
            
            // Make progress bar constraints
            let horizontalConstraint = NSLayoutConstraint(item: loadingView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: uiView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            uiView.addConstraint(horizontalConstraint)
            
            let verticalConstraint = NSLayoutConstraint(item: loadingView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: uiView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
            uiView.addConstraint(verticalConstraint)
            
            let widthConstraint = NSLayoutConstraint(item: loadingView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: doneViewSize)
            uiView.addConstraint(widthConstraint)
            
            let heightConstraint = NSLayoutConstraint(item: loadingView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: doneViewSize)
            uiView.addConstraint(heightConstraint)
            
            transparentView.alpha = 0
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                transparentView.alpha = 1
            }) { (result) -> Void in
                AsyncHelper.runAsync({ () -> () in
                    sleep(1)
                    }, finishCallback: { () -> () in
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            transparentView.alpha = 0
                            }, completion: { (result) -> Void in
                                onFinishAnimation()
                        })
                })
            }
        } else {
            onFinishAnimation()
        }
    }
    
    static func showActivityIndicator(inout activityIndicator: UIView?, containerView: UIView) {
        containerView.userInteractionEnabled = false
        if let activityIndicator = activityIndicator {
            activityIndicator.hidden = false
        } else {
            activityIndicator = createAndShowActivityIndicator(containerView)
        }
    }
    
    static func hideActivityIndicator(activityIndicator: UIView?, containerView: UIView) {
        containerView.userInteractionEnabled = true
        activityIndicator?.hidden = true
    }
    
    static func removeActivityIndicator(activityIndicator: UIView?) {
        activityIndicator?.removeFromSuperview()
    }
}