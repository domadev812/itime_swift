//
//  ThankYouViewController.swift
//  iTime
//
//  Created by Димас on 6/10/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit

class ThankYouViewController: UIViewController {
    
    @IBOutlet weak var buttonContinueToLogin: UIButton!
    
    @IBOutlet weak var buttonCancel: UIButton!
    @IBAction func buttonCancelAction(sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        buttonCancel.roundButton()
        buttonContinueToLogin.roundButton()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
