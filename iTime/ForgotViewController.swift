//
//  ForgotViewController.swift
//  iTime
//
//  Created by Albert Renat on 24/09/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit

class ForgotViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        btnBack.roundButton()
    }
    
    @IBAction func backAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
//        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func sendAction(sender: AnyObject) {
        sendEmail()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        sendEmail()
        return true
    }
    func sendEmail(){
        //Append
        let emailRegEx =  "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest=NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        let email = txtEmail.text
        
        if !emailTest.evaluateWithObject(email) {
            displayAlert("Error in work email", error: "Please enter a valid email.")
            txtEmail.text=""
            return
        }
        Manager.sharedInstance.resetPassword(email!) { (data) in
            if data.0 == 1 {
                self.displayAlert("Success", error: "Please check your email account !")
            }else {
                self.displayAlert("Error", error: data.1)
            }
        }
    }
}
