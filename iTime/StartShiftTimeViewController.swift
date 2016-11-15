//
//  StartShiftTimeViewController.swift
//  iTime
//
//  Created by Димас on 8/15/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit
import MessageUI

var isCheckout = false

class StartShiftTimeViewController: BaseViewController, ControlDelegate, MFMailComposeViewControllerDelegate {
    
    @IBAction func unwindToStartShift(segue: UIStoryboardSegue) {
    }
    
    var delegate: MenuDelegate?
    var menu: MenuView?
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBAction func buttonMenuAction(sender: UIButton) {
        delegate?.toggle()
    }
    @IBOutlet weak var buttonCheckin: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        buttonCheckin.roundButton()

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if menu != nil {
            menu?.alpha = 1
            menu?.imageViewAva.image = Manager.avatar
            return
        }
        menu = UINib(nibName: "Menu", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as? MenuView
        menu?.frame = CGRectMake(0 - self.view.frame.width / 5 * 3, 0, self.view.frame.width / 5 * 3, self.view.frame.height)
        view.addSubview(menu!)
        self.delegate = menu
        menu?.delegate = self
        
        menu?.imageViewAva.cornerRadius(CGRectGetHeight((menu?.imageViewAva.frame)!) / 2)
        menu?.viewBadge.cornerRadius(CGRectGetHeight((menu?.viewBadge.frame)!) / 2)
        if Manager.avatar != nil {
            self.menu?.imageViewAva.image = Manager.avatar
            return
        }
        if let data = Manager.loginData {
            if let name = data.firstname {
                if let surname = data.lastname {
                    menu?.labelUsername.text = name + " " + surname
                }
            }
        }
        
        if let data = Manager.loginData {
            if let avaLink = data.image {
                ImageLoader.sharedLoader.imageForUrl(avaLink, completionHandler: { (image, url) in
                    if image != nil {
                        Manager.avatar = image
                        self.menu?.imageViewAva.image = image
                    }
                })
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.menu?.alpha = 0
    }
    
    //MARK: - menu control delegate
    func initController(storyBoardID: String) {
        self.delegate?.toggle()
        let current_storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = current_storyboard.instantiateViewControllerWithIdentifier(storyBoardID)
        if let cameraVC = newVC as? DocumentViewController{
            cameraVC.isReport = true
        }
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    //MARK: - menu control delegate
    func logOut() {
        Manager.sharedInstance.removeUserFromDefaults()
        if let nav = self.navigationController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let main = storyboard.instantiateViewControllerWithIdentifier(loginControllerName)
            nav.setViewControllers([main], animated: true)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.delegate?.hide()
    }
}
