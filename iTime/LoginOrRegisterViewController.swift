//
//  LoginOrRegisterViewController.swift
//  iTime
//
//  Created by Димас on 6/11/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit

class LoginOrRegisterViewController: UIViewController {

    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonRegister: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        buttonLogin.roundButton()
        buttonRegister.roundButton()
//        let date = NSDate(timeIntervalSince1970: 1468113258)
//        print("timestamp for Anton \(1468113258) = \(date)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
