//
//  RegistrationViewController.swift
//  iTime
//
//  Created by Димас on 6/9/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit
import Foundation
import Darwin

var textForLabelUnderImage = ""

class RegistrationViewController: BaseViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let types = ["EMPLOYEE", "CONTRACTOR", "VISITOR"]
    
    @IBAction func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var textFieldFirstName: UITextField!
    
    @IBOutlet weak var textFieldLastName: UITextField!
    
    @IBOutlet weak var textFieldDOB: UITextField!
    
    @IBOutlet weak var textFieldMobNo: UITextField!
    
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textType: UITextField!
    
    @IBOutlet weak var buttonRegister: UIButton!
    @IBAction func buttonRegisterAction(sender: UIButton) {
        
        if textFieldFirstName.text?.characters.count < 2 {
            displayAlert("Error in FirstName", error: "It should be 2+ symbols")
            return
        }
        if textFieldLastName.text?.characters.count < 2 {
            displayAlert("Error in LastName", error: "It should be 2+ symbols")
            return
        }
        if textFieldDOB.text == "" {
            displayAlert("Error in DOB", error: "Enter date of birth")
            return
        }
        var asew = textFieldMobNo.text?.characters.count
        if (textFieldMobNo.text?.characters.count != 11) {
            displayAlert("Error in MobNo", error: "Enter correct mobile number")
            return
        }
        if textFieldPassword.text?.characters.count < 3 {
            displayAlert("Error in password", error: "Password must be longer then 3 symbols")
            return
        }
        if textType.text == "" {
            displayAlert("Error in password", error: "Select the user type.")
            return
        }
        
        //Append
        
        let phoneRegEx =  "^07[0-9]{9}$"
        
        let phoneTest=NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        
        if !phoneTest.evaluateWithObject(textFieldMobNo.text) {
            displayAlert("Error in MobNo", error: "Enter correct mobile number")
            return
        }
        
        //End
        
        
        textForLabelUnderImage = textFieldFirstName.text! + " " + textFieldLastName.text!
//        showActivity()
//        Manager.sharedInstance.checkNumber(self, phone: textFieldMobNo.text!) { (go) in
//            print("done")
//            self.hideActivity()
//            if !go {
        Manager.registerParams["firstname"] = self.textFieldFirstName.text!
        Manager.registerParams["lastname"] = self.textFieldLastName.text!
        Manager.registerParams["dob"] = self.textFieldDOB.text!
        Manager.registerParams["mob"] = self.textFieldMobNo.text!
        Manager.registerParams["password"] = Manager.sharedInstance.md5(string: self.textFieldPassword.text!)
        Manager.registerParams["type"] = self.textType.text!
        
                self.segue("picker");
        
//            } else {
//                self.displayAlert("Sorry", error: "This phone number already exists")
//            }
//        }
    }
    
    var datePicker = UIDatePicker()
    var dateFormater = NSDateFormatter()
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        buttonRegister.roundButton()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerMode = UIDatePickerMode.Date
        dateFormater.dateFormat = "YYYY-MM-dd"
        textFieldDOB.inputView = datePicker
        datePicker.addTarget(self, action: #selector(
            setDateOfBirth(_:)), forControlEvents: UIControlEvents.ValueChanged)

        let pickerViewType = UIPickerView()
        pickerViewType.delegate=self
        pickerViewType.tag=1
        textType.inputView = pickerViewType
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    //MARK: - open/hide kb
    func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 40
        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsetsZero
        self.scrollView.contentInset = contentInset
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //self.view.endEditing(true)
        if textField == self.textFieldFirstName {
            textFieldLastName.becomeFirstResponder()
        } else if textField == textFieldLastName {
            textFieldDOB.becomeFirstResponder()
        } else if textField == textFieldDOB {
            textFieldMobNo.becomeFirstResponder()
        } else if textField == textFieldMobNo {
            textFieldPassword.becomeFirstResponder()
        } else if textField == textFieldPassword {
            self.view.endEditing(true)
            buttonRegisterAction(UIButton())
        }
        return false
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
//    
//    override func keyDown(theEvent: NSEvent!) // A key is pressed
//    {
//        
//    }
//    
//    override func keyUp(theEvent: NSEvent!)
//    {
//        
//    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    func setDateOfBirth (sender: UIDatePicker){
        textFieldDOB.text = dateFormater.stringFromDate(sender.date)
    }
    
    //MARK: UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 1  {
            return types.count
        } else  {
            return types.count
        }
        
        //return 1
    }
    //MARK: UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1  {
            return types[row]
        } else  {
            return types[row]
        }
        //return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1   {
            textType.text=types[row]
        } else {
            textType.text=types[row]
        }
        
    }
}
