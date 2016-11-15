//
//  ShiftTimeViewController.swift
//  iTime
//
//  Created by Димас on 6/11/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit
import MessageUI

class ShiftTimeViewController: BaseViewController, ControlDelegate, MFMailComposeViewControllerDelegate {

    var maxHours = 6
    var delegate: MenuDelegate?
    var menu: MenuView?
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var buttonMenu: UIButton!
    @IBAction func buttonMenuAction(sender: UIButton) {
        delegate?.toggle()
    }
    
    @IBOutlet weak var buttonDocs: UIButton!
    @IBAction func buttonDocsAction(sender: UIButton) {
        //Manager.sharedInstance.cheating()
    }
    
    @IBOutlet weak var labelCurrentDate: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    //@IBOutlet weak var viewWithTime: UIView!
    
    @IBOutlet weak var labelHours: UILabel!
    
    @IBOutlet weak var labelTimeSeparator: UILabel!
    
    @IBOutlet weak var labelMinutes: UILabel!
    
    @IBOutlet weak var labelSeconds: UILabel!
    
    @IBOutlet weak var labelShiftStarted: UILabel!
    
    @IBOutlet weak var buttonCheckout: UIButton!
    @IBAction func buttonCheckoutAction(sender: UIButton) {
        
        DialogHelper.showAskAlertOnPVC("Stop Shift Tracker?") { (act) in
            if act {
                self.showActivity()
                
                Manager.sharedInstance.checkout(self) { (result) in
                    if result {
                        isCheckout = true
                        self.hideActivity()
                        Manager.checkoutFlag = true
                        Manager.locationController.stopUpdate()
                        if (self.userDefaults.valueForKey("shiftStarted") as? NSDate) != nil {
                            self.userDefaults.removeObjectForKey("shiftStarted")
                            self.userDefaults.synchronize()
                            //self.segue("checkout")
//                            self.segue("checkoutSelfie")
                            self.segue("checkOutLocation")
                        }
                        
                    } else {
                        self.displayAlert("Can't checkout", error: "")
                    }
                }

            }
        }
        
    }
    
    
    // switching elements
    
    @IBOutlet weak var imageViewClock: UIImageView!
    @IBOutlet weak var labelTimeAtwork: UILabel!
    @IBOutlet weak var labelbottomSide: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentDateAsDate = NSDate()
        let df = NSDateFormatter()
        df.dateFormat = "EEE d MMM yy"
        
        
        self.labelCurrentDate.text = df.stringFromDate(currentDateAsDate)

        magicSwitcher()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(magicSwitcher), userInfo: nil, repeats: true)

        buttonCheckout.roundButton()
        //viewWithTime.cornerRadius(20)
        //viewWithTime.layer.borderColor = UIColor.whiteColor().CGColor
        //viewWithTime.layer.borderWidth = 1
        //viewWithTime.backgroundColor = UIColor.clearColor()
        
        //MARK: - start updating locations
        Manager.locationController.startUpdating()

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
    
    var timer:NSTimer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy-MM-dd-kk-mm"
        
        
        //setCurrentTime()

        // Do any additional setup after loading the view.
    }
    var first = true
    let clockImage = UIImage(named: "Clock")
    let timerImage = UIImage(named: "Timer")
    var counter = 0
    
    
    /*func magicSwitcher() {
        if counter < 10 {
            first = true
        } else {
            first = false
            if counter > 19 {
                counter = 0
            }
        }
        counter += 1
        if first {
            first = false
            self.imageViewClock.image = timerImage
            let date = NSDate()
            if let shiftstarted = userDefaults.valueForKey("shiftStarted") as? NSDate {
                // coutn dif
                let time = TIME(date: shiftstarted)
                if  time.hours < 10 {
                    self.labelHours.text = "0\(time.hours)"
                } else {
                    self.labelHours.text = "\(time.hours)"
                }
                if time.minutes < 10 {
                    self.labelMinutes.text = "0\(time.minutes)"
                } else {
                    self.labelMinutes.text = "\(time.minutes)"
                }
                if time.seconds < 10 {
                    self.labelSeconds.text = "0\(time.seconds)"
                } else {
                    self.labelSeconds.text = "\(time.seconds)"
                }
                self.labelTimeAtwork.text = "Shift started"
                timeBetweenDate(shiftstarted, endDate: date)
                var h = ""
                var m = ""
                var s = ""
                if pastHours < 10 {
                    h = "0\(pastHours)"
                } else {
                    h = "\(pastHours)"
                }
                if pastMinutes < 10 {
                    m = "0\(pastMinutes)"
                } else {
                    m = "\(pastMinutes)"
                }
                if pastSeconds < 10 {
                    s = "0\(pastSeconds)"
                } else {
                    s = "\(pastSeconds)"
                }
                self.labelbottomSide.text = "Time at work \(h):\(m):\(s)"
                
                
            } else {
                userDefaults.setObject(date, forKey: "shiftStarted")
                userDefaults.synchronize()
                let time = TIME(date: date)
                if  time.hours < 10 {
                    self.labelHours.text = "0\(time.hours)"
                } else {
                    self.labelHours.text = "\(time.hours)"
                }
                if time.minutes < 10 {
                    self.labelMinutes.text = "0\(time.minutes)"
                } else {
                    self.labelMinutes.text = "\(time.minutes)"
                }
                if time.seconds < 10 {
                    self.labelSeconds.text = "0\(time.seconds)"
                } else {
                    self.labelSeconds.text = "\(time.seconds)"
                }
                self.labelTimeAtwork.text = "Shift started"
                let shiftstarted = userDefaults.valueForKey("shiftStarted") as! NSDate
                timeBetweenDate(shiftstarted, endDate: date)
                var h = ""
                var m = ""
                var s = ""
                if pastHours < 10 {
                    h = "0\(pastHours)"
                } else {
                    h = "\(pastHours)"
                }
                if pastMinutes < 10 {
                    m = "0\(pastMinutes)"
                } else {
                    m = "\(pastMinutes)"
                }
                if pastSeconds < 10 {
                    s = "0\(pastSeconds)"
                } else {
                    s = "\(pastSeconds)"
                }
                self.labelbottomSide.text = "Time at work \(h):\(m):\(s)"
            }

        } else {
            first = true
            self.imageViewClock.image = clockImage
            self.labelTimeAtwork.text = "Time at work"
            let currentDate = NSDate()
            let shiftstarted = userDefaults.valueForKey("shiftStarted") as! NSDate
            timeBetweenDate(shiftstarted, endDate: currentDate)
            if  pastHours < 10 {
                self.labelHours.text = "0\(pastHours)"
            } else {
                self.labelHours.text = "\(pastHours)"
            }
            if pastMinutes < 10 {
                self.labelMinutes.text = "0\(pastMinutes)"
            } else {
                self.labelMinutes.text = "\(pastMinutes)"
            }
            if pastSeconds < 10 {
                self.labelSeconds.text = "0\(pastSeconds)"
            } else {
                self.labelSeconds.text = "\(pastSeconds)"
            }
            let time = TIME(date: shiftstarted)
            var h = ""
            var m = ""
            var s = ""
            if time.hours < 10 {
                h = "0\(time.hours)"
            } else {
                h = "\(time.hours)"
            }
            if time.minutes < 10 {
                m = "0\(time.minutes)"
            } else {
                m = "\(time.minutes)"
            }
            if time.seconds < 10 {
                s = "0\(time.seconds)"
            } else {
                s = "\(time.seconds)"
            }
            self.labelbottomSide.text = "Shift started \(h):\(m):\(s)"
            
        }
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()

    }*/
    
    
   func magicSwitcher() {
        if counter < 10 {
            first = true
        } else {
            first = false
            if counter > 19 {
                counter = 0
            }
        }
        counter += 1
        if first {
            first = false
            let currentDate = NSDate()
            
            if let shiftstarted = userDefaults.valueForKey("shiftStarted") as? NSDate {
                timeBetweenDate(shiftstarted, endDate: currentDate)
            }
            else {
                userDefaults.setObject(currentDate, forKey: "shiftStarted")
                userDefaults.synchronize()
            }
            
            let shiftstarted = userDefaults.valueForKey("shiftStarted") as! NSDate
            
            
            if  pastHours < 10 {
                self.labelHours.text = "0\(pastHours)"
            } else {
                self.labelHours.text = "\(pastHours)"
            }
            if pastMinutes < 10 {
                self.labelMinutes.text = "0\(pastMinutes)"
            } else {
                self.labelMinutes.text = "\(pastMinutes)"
            }
            if pastSeconds < 10 {
                self.labelSeconds.text = "0\(pastSeconds)"
            } else {
                self.labelSeconds.text = "\(pastSeconds)"
            }
            let time = TIME(date: shiftstarted)
            var h = ""
            var m = ""
            //var s = ""
            if time.hours < 10 {
                h = "0\(time.hours)"
            } else {
                h = "\(time.hours)"
            }
            if time.minutes < 10 {
                m = "0\(time.minutes)"
            } else {
                m = "\(time.minutes)"
            }
            /*if time.seconds < 10 {
                s = "0\(time.seconds)"
            } else {
                s = "\(time.seconds)"
            }*/
            self.labelbottomSide.text = "Your shift started at \(h):\(m)"
            
            
        } else {
            first = true
            let currentDate = NSDate()
            let shiftstarted = userDefaults.valueForKey("shiftStarted") as! NSDate
            timeBetweenDate(shiftstarted, endDate: currentDate)
            if  pastHours < 10 {
                self.labelHours.text = "0\(pastHours)"
            } else {
                self.labelHours.text = "\(pastHours)"
            }
            if pastMinutes < 10 {
                self.labelMinutes.text = "0\(pastMinutes)"
            } else {
                self.labelMinutes.text = "\(pastMinutes)"
            }
            if pastSeconds < 10 {
                self.labelSeconds.text = "0\(pastSeconds)"
            } else {
                self.labelSeconds.text = "\(pastSeconds)"
            }
            /*let time = TIME(date: shiftstarted)
            var h = ""
            var m = ""
            var s = ""
            if time.hours < 10 {
                h = "0\(time.hours)"
            } else {
                h = "\(time.hours)"
            }
            if time.minutes < 10 {
                m = "0\(time.minutes)"
            } else {
                m = "\(time.minutes)"
            }
            if time.seconds < 10 {
                s = "0\(time.seconds)"
            } else {
                s = "\(time.seconds)"
            }*/
            self.labelbottomSide.text = "Your shift will end at 15:00"
            
        }
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
    }
    
    func everySecond() {
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.menu?.alpha = 0
        timer?.invalidate()
        timer = nil
        
        //self.delegate?.hide()
        
        //kostblJIb
        //Manager.locatinController.stopUpdate()

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
    
    func logOut() {
        Manager.sharedInstance.removeUserFromDefaults()
        if let nav = self.navigationController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let main = storyboard.instantiateViewControllerWithIdentifier(loginControllerName)
            nav.setViewControllers([main], animated: true)
            //self.navigationController?.popToRootViewControllerAnimated(true)
        }
//        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    //MARK: - timer funcs
    var count = 0
    //var date:NSDate?
    var pastHours = 0
    var pastMinutes = 0
    var pastSeconds = 0
    let dateFormatter = NSDateFormatter()
    
  /*  func setCurrentTime() {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        if count % 2 == 0 {
            UIView.animateWithDuration(0.1) {
                self.labelTimeSeparator.alpha = 1
            }
        } else {
            UIView.animateWithDuration(0.1) {
                self.labelTimeSeparator.alpha = 0
            }
        }
        if minutes < 10 {
            labelMinutes.text = "0\(minutes)"
        } else {
            labelMinutes.text = "\(minutes)"
        }
        if hour < 10 {
            labelHours.text = "0\(hour)"
        } else {
            labelHours.text = "\(hour)"
        }
        count += 1
        print("repeats: \(count)")
        self.date = date
        
        
        dataOptions()
        timeBetweenDate(startDATE!, endDate: endDATE!)
        
        let components2 = calendar.components([.Hour, .Minute], fromDate: startDATE!)
        
        if components2.minute < 10 {
            labelShiftStarted.text = "Shift started at \(components2.hour):0\(components2.minute)"
        } else {
            labelShiftStarted.text = "Shift started at \(components2.hour):\(components2.minute)"
        }
//        if pastMinutes < 10 {
//            .text = "Time of Work:\(pastHours):0\(pastMinutes)"
//        } else {
//            labelTimeOfWork.text = "Time of Work: \(pastHours):\(pastMinutes)"
//        }
        
    } */
    
    func timeBetweenDate(startDate: NSDate, endDate: NSDate)
    {
        let calendar = NSCalendar.currentCalendar()
        
        let components = calendar.components([.Minute, .Second], fromDate: startDate, toDate: endDate, options: [])
        pastSeconds = components.second
        minutesToHoursMinutes(components.minute)
        
    }
    
    func minutesToHoursMinutes (minutes : Int) {
        pastMinutes = minutes % 60
        pastHours = minutes / 60
        let secondsSpent = pastHours * 60 * 60 + pastMinutes * 60 + pastSeconds
        print("total seconds = \(secondsSpent)")
        self.fillProgress(withMaxHours: maxHours, currentSeconds: secondsSpent)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.delegate?.hide()
    }
    
    //MARK: - progres fill
    func fillProgress(withMaxHours max: Int, currentSeconds: Int) {
        let maxSeconds = max * 3600
        
        self.progressView.progress = Float(currentSeconds) / Float(maxSeconds)
    }

    
}

class TIME {
    var hours: Int
    var minutes: Int
    var seconds: Int
    init(date : NSDate) {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Minute, .Hour, .Second], fromDate: date)
        self.hours = components.hour
        self.minutes = components.minute
        self.seconds = components.second
    }
}
