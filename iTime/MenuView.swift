//
//  MenuView.swift
//  iTime
//
//  Created by Димас on 6/9/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit

enum MenuState {
    case Close, Open
}

protocol MenuDelegate {
    func toggle()
    func hide()
}

@objc protocol ControlDelegate {
    func initController(storyBoardID: String)
    //func sendMail()
    func logOut()
}

class MenuView: UIView, MenuDelegate {
    
    var state: MenuState = .Close
    
    var delegate: ControlDelegate?
    
    
    @IBOutlet weak var viewBadge: UIView!
    @IBOutlet weak var labelNotificationsNumber: UILabel!
    @IBOutlet weak var imageViewAva: UIImageView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var viewWithAvatar: UIView!
    
    @IBAction func btnCalendarAction(sender: AnyObject) {
        delegate?.initController("CalendarViewController")
    }
    @IBAction func buttonSettingsAction(sender: UIButton) {
        delegate?.initController("SettingsViewController")
    }
    
    @IBAction func buttonShiftsAction(sender: UIButton) {
        delegate?.initController("MyShiftsViewController")
    }
    
    @IBAction func buttonAboutAction(sender: UIButton) {
        print("about")
    }
    @IBAction func btnDocumentsAction(sender: AnyObject) {
        delegate?.initController("DocumentsViewController")
        print("document")
    }
    
    @IBAction func buttonReportAction(sender: UIButton) {
        delegate?.initController("DocumentViewController")
        print("report")
        //delegate?.sendMail()
    }
    
    @IBAction func buttonLogOutAction(sender: UIButton) {
        DialogHelper.showAskAlertOnPVC("Are you sure?") { (act) in
            if act {
                self.delegate?.logOut()
                Manager.avatar = nil
                Manager.avatarLink = ""
            }
        }
    }
    
    
   internal func hide() {
        state = .Close
        UIView.animateWithDuration(0.3) {
            self.frame.origin.x = -self.frame.width
            self.alpha = 0
        }
    }

   private func show() {
        state = .Open
    imageViewAva.cornerRadius(CGRectGetHeight(imageViewAva.frame)/2)
        UIView.animateWithDuration(0.3) {
            self.frame.origin.x = 0
            self.alpha = 1
        }
    }
    
    func toggle() {
        if state == .Close {
            show()
        } else {
            hide()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userInteractionEnabled = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panner(_:)))
        addGestureRecognizer(pan)
        let viewProfileGesture = UITapGestureRecognizer(target: self, action: #selector(viewProfile(_:)))
        addGestureRecognizer(viewProfileGesture)
        
    }
    
    
    func panner(pan: UIPanGestureRecognizer) {
        let translation = pan.translationInView(self)
        pan.setTranslation(CGPointZero, inView: self)
        if translation.x < 0 && translation.x < -10 {
            hide()
            return
        }
        if self.frame.origin.x + translation.x <= 0 {
            self.frame.origin.x += translation.x
            
        }
        if pan.state == .Ended {
            if  self.center.x < 0{
                hide()
            } else {
                show()
            }
        }
    }
    
    func viewProfile(tap: UITapGestureRecognizer) {
        delegate?.initController("ProfileViewController")
    } 
    
    func notifications() {
        delegate?.initController("NotificationsViewController")
    }
}
