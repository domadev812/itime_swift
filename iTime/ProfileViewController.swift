//
//  ProfileViewController.swift
//  iTime
//
//  Created by Димас on 6/10/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let photoPicker = UIImagePickerController()
    var chosenImage:UIImage?
    var imagePicked: Bool?
    var datePicker = UIDatePicker()
    var dateFormater = NSDateFormatter()
    
    var pickOptionForJobTitle = ["Architectural Glass and Metal Technician", "Brick and Stone Mason", "Cement (Concrete) Finisher", "Cement Mason", "Concrete Pump Operator", "Construction Boilermaker", "Construction Craft Worker", "Construction Millwright", "Drywall Finisher and Plasterer", "Electrician - Construction and Maintenance", "Electrician - Domestic and Rural", "Exterior Insulated Finish Systems Mechanic", "Floor Covering Installer", "General Carpenter", "Hazardous Materials Worker", "Heat and Frost Insulator", "Heavy Equipment Operator - Dozer", "Heavy Equipment Operator - Excavator", "Heavy Equipment Operator - Tractor Loader Backhoe", "Hoisting Engineer - Mobile Crane Operator 1", "Hoisting Engineer - Mobile Crane Operator 2", "Hoisting Engineer - Tower Crane Operator", "Ironworker - Generalist", "Ironworker - Structural and Ornamental", "Native Residential Construction Worker", "Painter and Decorator - Commercial and Residential", "Painter and Decorator - Industrial", "Plumber", "Powerline Technician", "Precast Concrete Erector", "Precast Concrete Finisher", "Refractory Mason", "Refrigeration and Air Conditioning Systems Mechanic", "Reinforcing Rodworker", "Residential Air Conditioning Systems Mechanic", "Residential (Low Rise) Sheet Metal Installer", "Restoration Mason", "Roofer", "Sheet Metal Worker", "Sprinkler and Fire Protection Installer", "Steamfitter", "Terrazzo, Tile and Marble Setter"]

    
    @IBOutlet weak var buttonBack: UIButton!
    @IBAction func buttonBackAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBOutlet weak var buttonEdit: UIButton!
    @IBAction func buttonEditAction(sender: UIButton) {
        if !editable {
            buttonEdit.setTitle("Save", forState: .Normal)
            editable = true
            for textField in textFields {
                textField.userInteractionEnabled = true
            }
        } else {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if textFieldDOB.text == "" {
                displayAlert("Error in DOB", error: "Enter date of birth")
                return
            }
            let phoneRegEx =  "^07[0-9]{9}$"
            let phoneTest=NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
            if !phoneTest.evaluateWithObject(textFieldMOBNo.text) {
                displayAlert("Error in MobNo", error: "Enter correct mobile number")
                return
            }
            //Append
            let emailRegEx =  "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            
            let emailTest=NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            
            if !emailTest.evaluateWithObject(textFieldWorkEmail.text) {
                displayAlert("Error in work email", error: "Please enter a valid email.")
                textFieldWorkEmail.text=""
                return
            }
            saveData()
            buttonEdit.setTitle("Edit", forState: .Normal)
            editable = false
            for textField in textFields {
                textField.userInteractionEnabled = false
            }
        }
    }
    
    @IBOutlet weak var imageViewAvatar: UIImageView!
    
    @IBOutlet weak var viewBadge: UIView!
    
    @IBOutlet weak var lableNotificationsNumber: UILabel!
    
    @IBOutlet weak var buttonEditPhoto: UIButton!
    @IBAction func buttonEditPhotoAction(sender: UIButton) {
        creatingActionSheet()
    }
    
    @IBOutlet weak var textFieldFirstName: UITextField!
    
    @IBOutlet weak var textFieldLastName: UITextField!
    
    @IBOutlet weak var textFieldDOB: UITextField!
    
    @IBOutlet weak var textFieldMOBNo: UITextField!
    
    @IBOutlet weak var textFieldCSCSNo: UITextField!
    
    @IBOutlet weak var textFieldCSCSExpiryDate: UITextField!
    
    @IBOutlet weak var textFieldCompanyName: UITextField!
    
    @IBOutlet weak var textFieldJobTitle: UITextField!
    
    @IBOutlet weak var textFieldWorkEmail: UITextField!
    
    @IBOutlet weak var buttonMyShifts: UIButton!
    @IBAction func buttonMyShiftsAction(sender: UIButton) {
        segue("openCalendarSegue")
    }
    @IBOutlet weak var buttonDocuments: UIButton!
    @IBAction func buttonDocumentsAction(sender: UIButton) {
        self.initControllerWithName(documentsController)
    }
    
//    @IBOutlet weak var buttonNotifications: UIButton!
//    @IBAction func buttonNotificationsAction(sender: UIButton) {
//        tapFunc()
//    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var editable = false
    var textFields = [UITextField]()
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configureDataInView()
        
        //viewBadge.addBorder()
        
        for textField in textFields {
            textField.userInteractionEnabled = false
        }
        if Manager.avatar != nil {
            self.imageViewAvatar.image = Manager.avatar
        }
        else if let data = Manager.loginData {
            if let avaLink = data.image {
                ImageLoader.sharedLoader.imageForUrl(avaLink, completionHandler: { (image, url) in
                    if image != nil {
                        Manager.avatar = image
                        self.imageViewAvatar.image = image
                    }
                })
            }
        }
        
        self.imageViewAvatar.cornerRadius(CGRectGetHeight(self.imageViewAvatar.frame) / 2)
        //self.viewBadge.cornerRadius(CGRectGetHeight(self.viewBadge.frame) / 2)
        
    }
    
    //MARK: - configure data in view
    
    func configureDataInView() {
        if let data = Manager.loginData {
            
            if let firstname = data.firstname {
                textFieldFirstName.text = firstname
            } else {
                textFieldFirstName.text = serverNIL
            }
            
            if let lastname = data.lastname {
                textFieldLastName.text = lastname
            } else {
                textFieldLastName.text = serverNIL
            }
            
            if let dob = data.dob {
                textFieldDOB.text = dob
            } else {
                textFieldDOB.text = serverNIL
            }
            
            if let mobNO = data.mob {
                textFieldMOBNo.text = mobNO
            } else {
                textFieldMOBNo.text = serverNIL
            }
            
            if let cscsNO = data.cscs {
                textFieldCSCSNo.text = cscsNO
            } else {
                textFieldCSCSNo.text = serverNIL
            }
            
            if let cscsExpiry = data.cscsdate {
                textFieldCSCSExpiryDate.text = cscsExpiry
            } else {
                textFieldCSCSExpiryDate.text = serverNIL
            }
            
            if let companyName = data.company {
                textFieldCompanyName.text = companyName
            } else {
                textFieldCompanyName.text = serverNIL
            }
            
            if let jobTitle = data.job {
                textFieldJobTitle.text = jobTitle
            } else {
                textFieldJobTitle.text = serverNIL
            }
            
            if let email = data.email {
                textFieldWorkEmail.text = email
            } else {
                textFieldWorkEmail.text = serverNIL
            }
            
        }
    }
    func saveData(){
        Manager.registerPhoto = imageViewAvatar.image!
        Manager.registerParams["dob"] = textFieldDOB.text!
        Manager.registerParams["mob"] = textFieldMOBNo.text!
        Manager.registerParams["cscs"] = textFieldCSCSNo.text!
        Manager.registerParams["cscsdate"] = textFieldCSCSExpiryDate.text!
        Manager.registerParams["job"] = textFieldJobTitle.text!
        Manager.registerParams["email"] = textFieldWorkEmail.text!
        
        showActivity()
        
        Manager.sharedInstance.updateUser(self) { (data) in
            self.hideActivity()
            if data.0 {
                DialogHelper.showActionAlert("success", message: data.1, controller: self, action: {
//                    self.segue("thankYou")
                })
            }
            self.displayAlert("Error", error: data.1)
        }
    }
    
    func checkCompanyNumber() -> Bool{
        let phoneRegEx =  "^[0-9]{6}$"
        
        let phoneTest=NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        
        if !phoneTest.evaluateWithObject(textFieldCompanyName.text!) {
            return false
        }
        return true
    }

    //MARK: tapGesture
    var tapGesture: UITapGestureRecognizer?
    
    
    func tapFunc() {
        let current_storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = current_storyboard.instantiateViewControllerWithIdentifier("NotificationsViewController")
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //hide now
        viewBadge.hidden = true
        
        // first version
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapFunc))
        viewBadge.userInteractionEnabled = true
        viewBadge.addGestureRecognizer(tapGesture!)
        
        photoPicker.delegate = self
        photoPicker.allowsEditing = false
        
        photoPicker.modalPresentationStyle = .FullScreen
        
        
//        textFields = [textFieldFirstName, textFieldLastName, textFieldDOB, textFieldMOBNo, textFieldCSCSNo, textFieldCSCSExpiryDate, textFieldCompanyName, textFieldJobTitle, textFieldWorkEmail]

        textFields = [textFieldDOB, textFieldMOBNo, textFieldCSCSNo, textFieldCSCSExpiryDate, textFieldJobTitle, textFieldWorkEmail]

        datePicker.datePickerMode = UIDatePickerMode.Date
        dateFormater.dateFormat = "YYYY-MM-dd"
        textFieldCSCSExpiryDate.inputView = datePicker
        datePicker.addTarget(self, action: #selector(setDateOfBirth(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        let dobPicker = UIDatePicker()
        dobPicker.datePickerMode = UIDatePickerMode.Date
        textFieldDOB.inputView = dobPicker
        dobPicker.addTarget(self, action: #selector(
            setDateOfDOB(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        let pickerViewForJobTitle=UIPickerView()
        pickerViewForJobTitle.delegate=self
        textFieldJobTitle.inputView=pickerViewForJobTitle
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func setDateOfBirth (sender: UIDatePicker){
        textFieldCSCSExpiryDate.text = dateFormater.stringFromDate(sender.date)
    }
    func setDateOfDOB (sender: UIDatePicker){
        textFieldDOB.text = dateFormater.stringFromDate(sender.date)
    }
    
    //MARK: - open/hide kb
    func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsetsZero
        self.scrollView.contentInset = contentInset
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    
    
    //MARK: - UIImgeickerViewDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageViewAvatar.image = image
            //Manager.avatar = nil
            Manager.avatar = image
            print("push new image to server")
            dismissViewControllerAnimated(true, completion: nil)
        }
    
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //MARK: - ActionSheet func
    func creatingActionSheet() {
        let camera = UIAlertAction(title: "Take photo", style: .Default) { (alert: UIAlertAction!) -> Void in
            print("take")
            self.photoPicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.photoPicker.cameraCaptureMode = .Photo
            self.presentViewController(self.photoPicker, animated: true, completion: nil)
        }
        let library = UIAlertAction(title: "Choose Photo", style: .Default) { (alert: UIAlertAction!) -> Void in
            print("CHoose photo")
            self.photoPicker.sourceType = .PhotoLibrary
            self.presentViewController(self.photoPicker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "cancel", style: .Cancel) { (alert: UIAlertAction!) -> Void in
            print("cancel")
            
        }
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        optionMenu.addAction(camera)
        optionMenu.addAction(library)
        optionMenu.addAction(cancel)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
//        if pickerView.tag == 1  {
//            return types.count
//        } else  {
//            return types.count
//        }
        
        return pickOptionForJobTitle.count
    }
    //MARK: UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
//        if pickerView.tag == 1  {
//            return types[row]
//        } else  {
//            return types[row]
//        }
        return pickOptionForJobTitle[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
//        if pickerView.tag == 1   {
//            textType.text=types[row]
//        } else {
//            textType.text=types[row]
//        }
        textFieldJobTitle.text=pickOptionForJobTitle[row]
    }
}
