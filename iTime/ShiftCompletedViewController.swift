//
//  ShiftCompletedViewController.swift
//  iTime
//
//  Created by Albert Renat on 24/09/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit

class ShiftCompletedViewController: BaseViewController, ControlDelegate {
    
    @IBOutlet weak var lblclockin: UILabel!
    @IBOutlet weak var lblclockout: UILabel!
    @IBOutlet weak var lblworktime: UILabel!
    @IBOutlet weak var lblovertime: UILabel!
    @IBOutlet weak var lbl_in_apm: UILabel!
    @IBOutlet weak var lbl_out_apm: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    
    
    var delegate: MenuDelegate?
    var menu: MenuView?
    var userDefaults = NSUserDefaults.standardUserDefaults()
    var checkDataModel = CheckDataModel?()
    var datas = [CheckData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    func loadData1(){
        showActivity()
        Manager.sharedInstance.getCheckData { (data) in
            self.hideActivity()
            if data.0 {
                self.checkDataModel = data.1 as? CheckDataModel
                self.datas = (self.checkDataModel?.data!)!
                self.lblclockin.text = self.datas.first?.checkin
                self.lblclockout.text = self.datas.last?.checkout
                let hhmm = self.getTimes((self.datas.last?.total_time)!)
                self.lblworktime.text = hhmm
                self.lblovertime.text = hhmm
            }
        }
    }
    func loadData(){
        self.lbl_in_apm.hidden = true
        self.lbl_out_apm.hidden = true
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        if let shiftstarted = userDefaults.valueForKey("shiftStarted") as? NSDate {
            self.lblclockin.text = dateFormatter.stringFromDate(shiftstarted)
            self.lblclockout.text = dateFormatter.stringFromDate(currentDate)
            self.lblworktime.text = calcTime(shiftstarted, endDate: currentDate)
            self.lblovertime.text = calcTime(shiftstarted, endDate: currentDate)
        }else {
            displayAlert("Error", error: "Server Error !")
            self.lblclockin.text = ""
            self.lblclockout.text = ""
            self.lblworktime.text = ""
            self.lblovertime.text = ""
        }
    }
    
    func calcTime(startDate: NSDate, endDate: NSDate) -> String{
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: startDate, toDate: endDate, options: [])
        return "\(components.hour):\(components.minute)"
    }
    
    func getTimes(total: String) -> String {
        return ""
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
    
    @IBAction func menuAction(sender: AnyObject) {
        delegate?.toggle()
    }
    
    @IBAction func doneAction(sender: AnyObject) {
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
