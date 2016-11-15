//
//  MainViewController.swift
//  iTime
//
//  Created by Димас on 6/10/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit
import MessageUI

class MainViewController: UIViewController, ControlDelegate, MFMailComposeViewControllerDelegate {
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
    }
    
    var delegate: MenuDelegate?
    
    @IBOutlet weak var menuButton: UIButton!
    @IBAction func menuButtonAction(sender: UIButton) {
        self.delegate?.toggle()
    }
    
    @IBOutlet weak var buttonLongitude: UIButton!
    @IBOutlet weak var buttonQRCode: UIButton!
    @IBOutlet weak var buttonVisualIdentity: UIButton!
    @IBOutlet weak var buttonCheckin: UIButton!
    
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        buttonLongitude.roundButton()
        buttonQRCode.roundButton()
        buttonVisualIdentity.roundButton()
        buttonCheckin.roundButton()
        buttonLongitude.addBorder()
        buttonQRCode.addBorder()
        buttonVisualIdentity.addBorder()
        
        
        if menu != nil {
            menu?.imageViewAva.image = Manager.avatar
            return
        }
        menu = UINib(nibName: "Menu", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as? MenuView
        menu?.frame = CGRectMake(0 - self.view.frame.width / 5 * 3, 0, self.view.frame.width / 5 * 3, self.view.frame.height)
        view.addSubview(menu!)
        self.delegate = menu
        menu?.delegate = self
        
        menu?.imageViewAva.cornerRadius(CGRectGetHeight((menu?.imageViewAva.frame)!) / 2)
        print("menu image ava height = \(menu?.imageViewAva.frame.height)")
        print("cgrect get height / 2 = \(CGRectGetHeight((menu?.imageViewAva.frame)!) / 2)")
        menu?.viewBadge.cornerRadius(CGRectGetHeight((menu?.viewBadge.frame)!) / 2)
        if let data = Manager.loginData {
            if let name = data.firstname {
                if let surname = data.lastname {
                    menu?.labelUsername.text = name + " " + surname
                }
            }
        }
        if Manager.avatar != nil {
            self.menu?.imageViewAva.image = Manager.avatar
            return
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
    
    
    var menu: MenuView?
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.delegate?.hide()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.delegate?.hide()
    }

    func initController(storyBoardID: String) {
        self.delegate?.toggle()
        let current_storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = current_storyboard.instantiateViewControllerWithIdentifier(storyBoardID)
        if let cameraVC = newVC as? DocumentViewController{
            cameraVC.isReport = true
        }
        self.navigationController?.pushViewController(newVC, animated: true)
    }

    func logOut() {
        Manager.sharedInstance.removeUserFromDefaults()
        if let nav = self.navigationController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let main = storyboard.instantiateViewControllerWithIdentifier(loginControllerName)
            nav.setViewControllers([main], animated: true)
            //self.navigationController?.popToRootViewControllerAnimated(true)
        }
        //self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
/*
    //MARK: - menu delegate
    func sendMail() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    //MARK: - mail funcs
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["report@itime.com"])
        mailComposerVC.setSubject("Report")
        mailComposerVC.setMessageBody("I'm reporting an accident at ", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }*/
}
