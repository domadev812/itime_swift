//
//  ConfirmViewController.swift
//  iTime
//
//  Created by Димас on 6/9/16.
//  Copyright © 2016 Димас. All rights reserved.
// thankYou

import UIKit

class ConfirmViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    var user_type_flag = false
    @IBAction func backButtonAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    var indicator: UIView?
    
    //Append
    var pickOptionForCompanyName = ["android", "iphone", "web", "design" ]
//    var pickOptionForJobTitle = ["boss", "worker", "programmer"]
    var pickOptionForJobTitle = ["Architectural Glass and Metal Technician", "Brick and Stone Mason", "Cement (Concrete) Finisher", "Cement Mason", "Concrete Pump Operator", "Construction Boilermaker", "Construction Craft Worker", "Construction Millwright", "Drywall Finisher and Plasterer", "Electrician - Construction and Maintenance", "Electrician - Domestic and Rural", "Exterior Insulated Finish Systems Mechanic", "Floor Covering Installer", "General Carpenter", "Hazardous Materials Worker", "Heat and Frost Insulator", "Heavy Equipment Operator - Dozer", "Heavy Equipment Operator - Excavator", "Heavy Equipment Operator - Tractor Loader Backhoe", "Hoisting Engineer - Mobile Crane Operator 1", "Hoisting Engineer - Mobile Crane Operator 2", "Hoisting Engineer - Tower Crane Operator", "Ironworker - Generalist", "Ironworker - Structural and Ornamental", "Native Residential Construction Worker", "Painter and Decorator - Commercial and Residential", "Painter and Decorator - Industrial", "Plumber", "Powerline Technician", "Precast Concrete Erector", "Precast Concrete Finisher", "Refractory Mason", "Refrigeration and Air Conditioning Systems Mechanic", "Reinforcing Rodworker", "Residential Air Conditioning Systems Mechanic", "Residential (Low Rise) Sheet Metal Installer", "Restoration Mason", "Roofer", "Sheet Metal Worker", "Sprinkler and Fire Protection Installer", "Steamfitter", "Terrazzo, Tile and Marble Setter"]
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageViewPickedImage: UIImageView!
    
    @IBOutlet weak var labelFirstAndLastName: UILabel!
    
    @IBOutlet weak var textFieldCSCS: UITextField!
    
    @IBOutlet weak var textFieldCSCSExpiry: UITextField!
    
    @IBOutlet weak var textFieldCompanyName: UITextField!
    
    @IBOutlet weak var textFieldJobTitle: UITextField!

    @IBOutlet weak var textFieldWorkEmail: UITextField!
    
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBAction func buttonConfirmAction(sender: UIButton) {
        
        //Append
        let emailRegEx =  "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest=NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        if !emailTest.evaluateWithObject(textFieldWorkEmail.text) {
            displayAlert("Error in work email", error: "Please enter a valid email.")
            textFieldWorkEmail.text=""
            return
        }
        if checkCompanyNumber() == false {
            displayAlert("Error in company number", error: "Enter correct company mumber")
            return
        }
        
        //end
        
        Manager.registerParams["cscs"] = textFieldCSCS.text!
        Manager.registerParams["cscsdate"] = textFieldCSCSExpiry.text!
        Manager.registerParams["company"] = "555"//textFieldCompanyName.text!
        Manager.registerParams["job"] = textFieldJobTitle.text!
        Manager.registerParams["email"] = textFieldWorkEmail.text!
        AsyncHelper.showActivityIndicator(&indicator, containerView: view)
        
        Manager.sharedInstance.registration(self, success: { res in
            AsyncHelper.hideActivityIndicator(self.indicator, containerView: self.view)
            if res.0 {
                DialogHelper.showActionAlert("Registration success", message: "Your id = \(res.1)", controller: self, action: {
                    self.segue("thankYou")
                })
            } else {
                self.displayAlert("Error", error: "server error!!!")
            }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        labelFirstAndLastName.text = textForLabelUnderImage
        buttonConfirm.roundButton()
        imageViewPickedImage.cornerRadius(CGRectGetHeight(imageViewPickedImage.frame) / 2)
        imageViewPickedImage.image = Manager.registerPhoto
    }
    var datePicker = UIDatePicker()
    var dateFormater = NSDateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = UIDatePickerMode.Date
        dateFormater.dateFormat = "YYYY-MM-dd"
        textFieldCSCSExpiry.inputView = datePicker
        datePicker.addTarget(self, action: #selector(
            setDateOfBirth(_:)), forControlEvents: UIControlEvents.ValueChanged)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
        //Append
//        let pickerViewForCompanyName=UIPickerView()
//        pickerViewForCompanyName.delegate=self
//        pickerViewForCompanyName.tag=1
//        textFieldCompanyName.inputView=pickerViewForCompanyName
        
        let pickerViewForJobTitle=UIPickerView()
        pickerViewForJobTitle.delegate=self
        pickerViewForJobTitle.tag=2
        textFieldJobTitle.inputView=pickerViewForJobTitle
        
        checkUserType()
        
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func checkUserType() -> Bool{
        if Manager.registerParams["type"] == "VISITOR" {
            textFieldCSCS.enabled = false
            textFieldJobTitle.enabled = false
            textFieldCSCSExpiry.enabled = false
            return true
        }else if Manager.registerParams["type"] == "CONTRACTOR" {
            Manager.registerParams["contractor"] = "contractor"
        }
        return false
    }
    
    func checkCompanyNumber() -> Bool{
        let phoneRegEx =  "^[0-9]{6}$"
        
        let phoneTest=NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        
        if !phoneTest.evaluateWithObject(textFieldCompanyName.text!) {
            return false
        }
        return true
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
        
        if textField == textFieldCSCS {
            textFieldCSCSExpiry.becomeFirstResponder()
        }
//        else if textField == textFieldCSCSExpiry {
//            textFieldCompanyName.becomeFirstResponder()
//        }
        else if textField == textFieldCompanyName {
            textFieldJobTitle.becomeFirstResponder()
        } else if textField == textFieldJobTitle {
            textFieldWorkEmail.becomeFirstResponder()
        } else if textField == textFieldWorkEmail {
            self.view.endEditing(true)
            buttonConfirmAction(UIButton())
        }
        
        //self.view.endEditing(true)
        return false
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    func setDateOfBirth (sender: UIDatePicker){
        textFieldCSCSExpiry.text = dateFormater.stringFromDate(sender.date)
    }
    
    //Append
    
    //MARK: UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 1  {
            return pickOptionForCompanyName.count
        } else  {
            return pickOptionForJobTitle.count
        }
        
        //return 1
    }
    
    //MARK: UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1  {
            return pickOptionForCompanyName[row]
        } else  {
            return pickOptionForJobTitle[row]
        }
        //return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1   {
            textFieldCompanyName.text=pickOptionForCompanyName[row]
        } else {
            textFieldJobTitle.text=pickOptionForJobTitle[row]
        }
        
    }
}
