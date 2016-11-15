//
//  Extensions.swift
//  iTime
//
//  Created by Димас on 6/9/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore


let serverNIL = "Server error"
let documentsController = "DocumentsController"


extension UIViewController: UITextViewDelegate  {
    //MARK: - formatter for string
    func formatDateByFormat(date: NSDate, format: String) -> String {
        let df = NSDateFormatter()
        df.dateFormat = format
        let output = df.stringFromDate(date)
        return output
    }
    //MARK: - custom short segue
    func segue(name: String) {
        self.performSegueWithIdentifier(name, sender: nil)
    }
    
    //MARK: - normal alert
    func displayAlert(title:String, error:String) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    //MARK: - alert with textfield
    func alertWithReason(message: (String) -> Void ) {
        let alert = UIAlertController(title: "Verification problem", message: "Please let us know why you cannot verify your location", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Message"
            //textField.text = "Some default text."
        })
        

        
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "SEND", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            print("Text field: \(textField.text)")
            message(textField.text!)
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    public func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView.textColor == UIColor.lightGrayColor(){
            textView.text = ""
            textView.textColor = UIColor.darkGrayColor()
        }
        return true
    }
   
    
    //MARK: - time to color
    func timeCounter(seconds: Int) -> UIColor {
        if seconds / 3600 >= 8 {
            return UIColor.greenColor()
        } else {
            return UIColor.grayColor()
        }
    }
    //MARK: - calendar color
    func getColor(type: Int) -> UIColor {
        if type == 1 {
            return UIColor(red: 0/255, green: 204/255, blue: 0/255, alpha: 1.0)
        }
        if type == 2 {
            return UIColor(red: 0/255, green: 153/255, blue: 255/255, alpha: 1.0)
        }
        if type == 3 {
            return UIColor(red: 255/255, green: 204/255, blue: 102/255, alpha: 1.0)
        }
        if type == 4 {
            return UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
        }
        return UIColor.clearColor()
    }

}
extension UIButton {
    func roundButton() -> UIButton {
        self.layer.masksToBounds = true
        let height = CGRectGetHeight(self.frame)
        self.layer.cornerRadius = height / 2
        return self
    }
    
}

extension UIView {
    func cornerRadius(cornerRadius:CGFloat) -> UIView {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
        return self
    }
    func addBorder() -> UIView {
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 1
        return self
    }
    
    func addShadow() -> UIView {
        let shadowPath = UIBezierPath(rect: bounds)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSizeMake(0.0, 5.0)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.CGPath
        return self
    }
    func addShadow(range: CGFloat) -> UIView {
        let shadowPath = UIBezierPath(rect: bounds)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSizeMake(0.0, range)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.CGPath
        return self
    }
    
    
    
//    func addShadow(r: Int, q: Int) -> UIView
//    {
//        let superview = self
//        
//        let shadowView = UIView(frame: CGRectMake(50, 50, 100, 100))
//        shadowView.layer.shadowColor = UIColor.blackColor().CGColor
//        shadowView.layer.shadowOffset = CGSizeZero
//        shadowView.layer.shadowOpacity = 0.5
//        shadowView.layer.shadowRadius = 5
//        
//        let view = MyView(frame: shadowView.bounds)
//        view.backgroundColor = UIColor.whiteColor()
//        view.layer.cornerRadius = 10.0
//        view.layer.borderColor = UIColor.grayColor().CGColor
//        view.layer.borderWidth = 0.5
//        view.clipsToBounds = true
//        
//        shadowView.addSubview(view)
//        superview.addSubview(shadowView)
//        return self
//    }
    
}