//
//  CalendarDetailsViewController.swift
//  iTime
//
//  Created by Димас on 7/6/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit

class TimeCell: UITableViewCell {
    // timeCell
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelState: UILabel!
    @IBOutlet weak var lblMainTime: UILabel!
    @IBOutlet weak var lblOtherTime: UILabel!
    
}

class CalendarDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PDTSimpleCalendarViewDelegate, PDTSimpleCalendarViewCellDelegate {
    
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonBack: UIButton!
    @IBAction func buttonBackAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBOutlet weak var calendarView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - incoming data from calendar
    var incoming_datas = [DataOfDay]()
    var detail_datas = [Data]()
    var dateClicked: NSDate?
    var dateFormatter = NSDateFormatter()
    let calendarController = PDTSimpleCalendarViewController()
    var selectedDate: NSDate!
    var firstFlag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.sectionHeaderHeight = 60
        
        initCalendar()
    }
    //MARK: - cell configurator
    func configCell_origin(tableView: UITableView, indexPath: NSIndexPath) -> TimeCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("timeCell", forIndexPath: indexPath) as! TimeCell
        var secondsFromGMT: Int { return NSTimeZone.localTimeZone().secondsFromGMT }
        var start = 0
        var out = 0
        var stringCheckins = "Recorded: "
        if let checkin =  incoming_datas[indexPath.row].checkinDate {
            start = checkin
            let startTime = NSDate(timeIntervalSince1970: Double(checkin + secondsFromGMT))
            stringCheckins += "\(formatData(startTime)) - "
            //cell.labelTime.text = "Checkin: \(formatData(startTime))"
        }
        
        if let checkout = incoming_datas[indexPath.row].checkoutDate {
            if checkout == 0 {
                stringCheckins += "In Progress"
                //cell.labelCheckout.text = "- In progress"
            } else {
                out = checkout
                let endTime = NSDate(timeIntervalSince1970: Double(checkout + secondsFromGMT))
                stringCheckins += "\(formatData(endTime))"
                //cell.labelCheckout.text = "Checkout: \(formatData(endTime))"
            }
        }
        cell.labelTime.text = stringCheckins
        if let totalSeconds = incoming_datas[indexPath.row].total {
            if totalSeconds != 0 {
                var delta = 0
                if out != 0 {
                    delta = out - start
                }
                cell.labelState.textColor = UIColor.blackColor()
                let totalMinutes = delta / 60
                let hours: Int = totalMinutes / 60
                let minutes = totalMinutes % 60
                let seconds = delta % 60
                var timeString = ""
                if hours == 0 {
                    timeString += "00"
                } else {
                    if hours < 10 {
                        timeString += "0\(hours)"
                    } else {
                        timeString += "\(hours)"
                    }
                }
                timeString += ":"
                if minutes == 0 {
                    timeString += "00"
                } else {
                    if minutes < 10 {
                        timeString += "0\(minutes)"
                    } else {
                        timeString += "\(minutes)"
                    }
                }
                timeString += ":"
                if seconds == 0 {
                    timeString += "00"
                } else {
                    if seconds < 10 {
                        timeString += "0\(seconds)"
                    } else {
                        timeString += "\(seconds)"
                    }
                }
                cell.labelState.text = "Total: \(timeString)"
            } else {
                cell.labelState.text = ""
            }
        }
        
        
        
        
        return cell
    }
    
    func configCell(tableView: UITableView, indexPath: NSIndexPath) -> TimeCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("timeCell", forIndexPath: indexPath) as! TimeCell
        var secondsFromGMT: Int { return NSTimeZone.localTimeZone().secondsFromGMT }
        
        if let type = detail_datas[indexPath.row].type {
            let sdate = getDate(detail_datas[indexPath.row].sdate!)
            let edate = getDate(detail_datas[indexPath.row].edate!)
            let total_time = detail_datas[indexPath.row].total!
            let status = detail_datas[indexPath.row].status!
            let mins = Int(total_time / 60)

            if status == "upcoming" {
                cell.labelTime.text = "Scheduled: \(formatDateString(sdate)) - \(mins)"
                cell.labelState.text = "Upcoming"
                cell.labelState.textColor = getColor(1)
            }else {
                cell.labelTime.text = "Recorded: \(formatDateString(sdate)) - \(mins)"
//                cell.lblOvertime.text = "\(calcTime(sdate, edate))"
                if type == 4 {
                    cell.labelState.text = "Absent"
                }else if type == 3{
                    cell.labelState.text = "Unpaid"
                }else {
                    cell.labelState.text = "Leave"
                }
                
                cell.labelState.textColor = getColor(type)
            }
        }
        return cell
    }
    
    func calcTime(startDate: NSDate, endDate: NSDate) -> String{
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: startDate, toDate: endDate, options: [])
        return "\(components.hour):\(components.minute)"
    }
    
    func formatData(date: NSDate) -> String {
        dateFormatter.dateFormat = "HH:mm"
        let output = dateFormatter.stringFromDate(date)
        return output
    }
    func getDate(strDate: String) -> NSDate {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        
        let date = dateFormatter.dateFromString(strDate)
        return date!
        
    }
    func formatDateString(date: NSDate) -> String {
        dateFormatter.dateFormat = "E d MMM yy HH:MM"
        let output = dateFormatter.stringFromDate(date)
        return output
    }
    func calcTime(sdate: NSDate, edate:NSDate) -> String {
        return ""
    }
    
    
    func initCalendar() {
        let previousOffset = NSDateComponents()
        previousOffset.month = 0
        let first = calendarController.calendar.dateByAddingComponents(previousOffset, toDate: self.selectedDate, options: .MatchFirst)
        
        calendarController.firstDate = first
        let offsetComponents = NSDateComponents()
        offsetComponents.month = 0
        let lastDate = calendarController.calendar.dateByAddingComponents(offsetComponents, toDate: self.selectedDate, options: .MatchFirst)
        calendarController.lastDate = lastDate
        calendarController.delegate = self
        calendarController.weekdayHeaderEnabled = true
        calendarController.weekdayTextType = .Short
        let calendar = calendarController.view
        calendar.frame = self.calendarView.bounds
        
        self.addChildViewController(calendarController)
        self.calendarView.addSubview(calendar)
    }
    

    //MARK: - tableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return incoming_datas.count
        return detail_datas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return configCell(tableView, indexPath: indexPath)
    }
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60))
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 60))
//        label.textAlignment = .Center
//        let df = NSDateFormatter()
//        df.dateFormat = "EEE d MMMM yy"
//        if dateClicked != nil {
//            let output = df.stringFromDate(dateClicked!)
//            label.text = output
//        }
//        label.textColor = UIColor.blackColor()
//        view.backgroundColor = UIColor.whiteColor()
//        view.addSubview(label)
//        
//        return view
//    }
    func simpleCalendarViewCell(cell: PDTSimpleCalendarViewCell!, shouldUseCustomColorsForDate date: NSDate!) -> Bool {
        return true
    }

    //MARK: - calendar delegate
    func simpleCalendarViewController(controller: PDTSimpleCalendarViewController!, didSelectDate date: NSDate!) {
        print("date = \(date)")
        self.selectedDate = date
//        self.detail_datas
        
    }
    func simpleCalendarViewController(controller: PDTSimpleCalendarViewController!, circleColorForDate date: NSDate!) -> UIColor!
    {
//        if firstFlag == true {
//            firstFlag = false
//            let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            dateFormatter.timeZone = NSTimeZone(name: "UTC")
//            
//            if self.selectedDate != nil {
//                let cal = NSCalendar.currentCalendar()
//                if cal.isDate(date, inSameDayAsDate: self.selectedDate!) {
//                    return UIColor.darkGrayColor()
//                }
//            }
//        }
        return UIColor.darkGrayColor()
        
    }
    func simpleCalendarViewController(controller: PDTSimpleCalendarViewController!, shouldUseCustomColorsForDate date: NSDate!) -> Bool {
        return true
    }
    func simpleCalendarViewController(controller: PDTSimpleCalendarViewController!, textColorForDate date: NSDate!) -> UIColor! {
        return UIColor.blackColor()
    }
}
