//
//  LoginViewController.swift
//  iTime
//
//  Created by Димас on 6/9/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate {
    
    
    
    @IBAction func buttonBackAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBOutlet weak var textFieldID: UITextField!
    
    @IBOutlet weak var textFieldPass: UITextField!

    @IBOutlet weak var buttonLogin: UIButton!
    @IBAction func buttonLoginAction(sender: UIButton) {
        let params = [
            "user": textFieldID.text!,
            "password": Manager.sharedInstance.md5(string: textFieldPass.text!)
        ]
        showActivity()
        Manager.sharedInstance.login(self, params: params) { data in
            self.hideActivity()
            if let data = data as? LoginData {
                if let user_id = data.internalIdentifier {
                    Manager.user_id = user_id
                    print("login now")
                    self.segue("loginSuccess")
                    //segue here
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        buttonLogin.roundButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldID.text = "matej@specto.com.hr"
        textFieldPass.text = "test"
//        textFieldID.text = "test@mail.com"
//        textFieldPass.text = "aaaaa"
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == textFieldID {
            textFieldPass.becomeFirstResponder()
        } else if textField == textFieldPass {
            self.view.endEditing(true)
            buttonLoginAction(UIButton())

        }
        return false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }


}
