//
//  CalendarViewController.swift
//  iTime
//
//  Created by Димас on 6/16/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit
//import PDTSimpleCalendar



class CalendarViewController: BaseViewController,  PDTSimpleCalendarViewDelegate, PDTSimpleCalendarViewCellDelegate {

    var dates: ColorCalendarModel?
    var checkins: [DataOfDay]?
    var detail_data = [Data]()
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBAction func buttonBackAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBOutlet weak var viewWithCalendar: UIView!
    
    
    let calendarController = PDTSimpleCalendarViewController()
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    func initCalendar() {
        let previousOffset = NSDateComponents()
        previousOffset.month = -1
        let first = calendarController.calendar.dateByAddingComponents(previousOffset, toDate: NSDate(), options: .MatchFirst)
        
        calendarController.firstDate = first
        let offsetComponents = NSDateComponents()
        offsetComponents.month = 1
        let lastDate = calendarController.calendar.dateByAddingComponents(offsetComponents, toDate: NSDate(), options: .MatchFirst)
        calendarController.lastDate = lastDate
        calendarController.delegate = self
        calendarController.weekdayHeaderEnabled = true
        calendarController.weekdayTextType = .Short
        let calendarView = calendarController.view
        calendarView.frame = self.viewWithCalendar.frame
        self.addChildViewController(calendarController)
        self.view.addSubview(calendarView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        Manager.sharedInstance.calendarTotal(self) { dates in
//            print("done")
//            self.dates = dates
//            if let allDates = self.dates?.data {
//                for obj in allDates {
//                    let dateToCheck = NSDate(timeIntervalSince1970: Double(obj.date!))
//                    self.dates_toCompare.append(dateToCheck)
//                }
//                self.initCalendar()
//            }
//        }
        self.showActivity()
        Manager.sharedInstance.getShifts(self) { (dates) in
            self.hideActivity()
            if dates.0 == 1 {
                self.dates = dates.3 as? ColorCalendarModel
                self.initCalendar()
            }else{
                self.initCalendar()
            }
        }
    }
    func getDayData(date: NSDate!){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        
        
    }
    
    //MARK: - prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "dayShiftDetailsSegue" {
            let nvc = segue.destinationViewController as! CalendarDetailsViewController
//            if checkins != nil {
//                nvc.incoming_datas = checkins!
//            }
//            if selectedDate != nil {
//                nvc.dateClicked = selectedDate
//            }
            if self.dates != nil {
//                nvc.detail_datas = getDetailData(self.dates!.data!)
                nvc.detail_datas = self.detail_data
                nvc.selectedDate = self.selectedDate!
            }
        }
    }
    
    func getDetailData(data: Array<Data>) -> Array<Data> {
        var temp = [Data]()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let calendar = NSCalendar.currentCalendar()
        for row in data {
            let sdate = dateFormatter.dateFromString(row.sdate!)
            if calendar.isDate(self.selectedDate!, inSameDayAsDate: sdate!){
                temp.append(row)
                print(row)
            }
        }
        return temp
    }
    
    //MARK: - calendar delegate
    var selectedDate: NSDate?
    func simpleCalendarViewController(controller: PDTSimpleCalendarViewController!, didSelectDate date: NSDate!) {
        print("date = \(date)")
        self.selectedDate = date
//        let calendar = NSCalendar.currentCalendar()
//        //let comp = calendar.component(.Day, fromDate: date)
//        
//        let offsetComponents = NSDateComponents()
//        offsetComponents.day = 1
//        
//        let dateSend = calendar.dateByAddingComponents(offsetComponents, toDate: date, options: .MatchFirst)
//        print("dateSend = \(dateSend)")
//        let timeStamp = dateSend!.timeIntervalSince1970
//        print("timeStamp = \(timeStamp)")
//        Manager.sharedInstance.getTimeForDate(Int(timeStamp)){ dataObject in
//            if dataObject.status != 1 {
//                self.displayAlert("Something went wrong", error: "")
//                return
//            }
//            if let checkins = dataObject.data {
//                self.checkins = checkins
//                self.performSegueWithIdentifier("dayShiftDetailsSegue", sender: nil)
//                for check in checkins {
//                    if let checkinTimeStamp = check.checkinDate {
//                        if let checkoutTimeStamp = check.checkoutDate {
//                            let checkinDate = NSDate(timeIntervalSince1970: Double(checkinTimeStamp))
//                            let checkoutDate = NSDate(timeIntervalSince1970: Double(checkoutTimeStamp))
//                            print("chekcin date = \(checkinDate)")
//                            print("checkout date = \(checkoutDate)")
//                            print("total = \(check.total!)")
//                        }
//                    }
//                }
//            }
//        }
        self.detail_data = getDetailData(self.dates!.data!)
        if self.detail_data.count > 0 {
            self.performSegueWithIdentifier("dayShiftDetailsSegue", sender: nil)
        }
    }
    var i = 0
    func simpleCalendarViewController(controller: PDTSimpleCalendarViewController!, circleColorForDate date: NSDate!) -> UIColor!
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        
        if let dataArray = dates?.data {
            if !dataArray.isEmpty {
                for obj in dataArray {
                    let cal = NSCalendar.currentCalendar()
//                    if cal.isDate(date, inSameDayAsDate: NSDate(timeIntervalSince1970: Double(obj.date!))) {
//                        if let total = obj.total {
//                            return self.timeCounter(total)
//                        }
//                    }
                    let sdate = dateFormatter.dateFromString(obj.sdate!)
                    if cal.isDate(date, inSameDayAsDate: sdate!) && obj.type != nil{
                        return self.getColor(obj.type!)
                    }

                }
            }
        }
        return UIColor.clearColor()

   }
    func simpleCalendarViewController(controller: PDTSimpleCalendarViewController!, shouldUseCustomColorsForDate date: NSDate!) -> Bool {
        return true
    }
    func simpleCalendarViewController(controller: PDTSimpleCalendarViewController!, textColorForDate date: NSDate!) -> UIColor! {
        return UIColor.blackColor()
    }
    
}
