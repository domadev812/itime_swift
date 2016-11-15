

import UIKit

class ShiftCell: UITableViewCell {
    
    @IBOutlet weak var imageViewTimer: UIImageView!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelState: UILabel!
    @IBOutlet weak var labelCheckout: UILabel!
    @IBOutlet weak var lblbottomTime: UILabel!
    @IBOutlet weak var lblOvertime: UILabel!
    
}

class MyShiftsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBAction func buttonBackAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgUpcoming: UIImageView!
    @IBOutlet weak var imgPast: UIImageView!
    
    //MARK: - incoming data from calendar
    var dates: ColorCalendarModel?
    var detail_datas = [Data]()
    var upcoming_data = [Data]()
    var past_data = [Data]()
    var dateFormatter = NSDateFormatter()
    var selectFlag = true
    var upcoming_count = 0
    var past_count = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.sectionHeaderHeight = 60
        showActivity()
        Manager.sharedInstance.getShifts(self) { (dates) in
            if dates.0 == 1 {
                self.upcoming_count = dates.1
                self.past_count = dates.2
                self.dates = dates.3 as? ColorCalendarModel
                self.detail_datas = self.dates!.data!
                self.setTableData(self.dates!.data!, result: { (upcoming, past) in
                    self.upcoming_data = upcoming
                    self.past_data = past
                })
                self.hideActivity()
                self.tableView.reloadData()
            }
        }
    }
    //MARK: - cell configurator
    func configCell(tableView: UITableView, indexPath: NSIndexPath) -> ShiftCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ShiftCell", forIndexPath: indexPath) as! ShiftCell
        var secondsFromGMT: Int { return NSTimeZone.localTimeZone().secondsFromGMT }
        
        var type: Int?
        var sdate: NSDate?
        var edate: NSDate?
        var status: String?
        var total: Int?
        
        if selectFlag == true {
            type = upcoming_data[indexPath.row].type!
            sdate = getDate(upcoming_data[indexPath.row].sdate!)
            edate = getDate(upcoming_data[indexPath.row].edate!)
            status = upcoming_data[indexPath.row].status!
            total = upcoming_data[indexPath.row].total!
        }else {
            type = past_data[indexPath.row].type!
            sdate = getDate(past_data[indexPath.row].sdate!)
            edate = getDate(past_data[indexPath.row].edate!)
            status = past_data[indexPath.row].status!
            total = past_data[indexPath.row].total!
        }
        let mins = Int(total! / 60)
        cell.labelTime.text = "Scheduled: \(formatDateString(sdate!))-\(mins)"
        
        if status == "upcoming" {
            cell.labelState.text = "Upcoming"
            cell.lblbottomTime.text = ""
            cell.labelState.textColor = getColor(1)
            cell.lblOvertime.text = ""
        }else if status == "past" {
            cell.lblbottomTime.text = "Recorded: \(formatDateString(edate!))"
            //                cell.lblOvertime.text = "\(calcTime(sdate, edate))"
            if type == 4 {
                cell.labelState.text = "Absent"
                cell.labelState.textColor = getColor(4)
            }else {
                cell.labelState.text = "Done"
                cell.labelState.textColor = getColor(2)
            }
            cell.lblOvertime.text = "\(mins) min"
        }
        print("\(type!) ==> \(cell.labelState.textColor)")
        
        return cell
    }
    
    func setTableData(total: Array<Data>, result: (Array<Data>, Array<Data>) -> ()) {
        var upcoming = [Data]()
        var past = [Data]()
        
        for data in total {
            if data.status! == "upcoming" {
                upcoming.append(data)
            }else if data.status! == "past" {
                past.append(data)
            }
        }
        result(upcoming, past)
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
    
    @IBAction func btnUpcomingAction(sender: AnyObject) {
        if selectFlag == false {
            selectFlag = true
            imgUpcoming.hidden = false
            imgPast.hidden = true
            self.tableView.reloadData()
        }
    }
    @IBAction func btnPastAction(sender: AnyObject) {
        if selectFlag == true {
            selectFlag = false
            imgUpcoming.hidden = true
            imgPast.hidden = false
            self.tableView.reloadData()
        }
    }
    
    //MARK: - tableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return incoming_datas.count
        if selectFlag == true {
            return upcoming_count
        }else{
            return past_count
        }
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
//        let output = "label title"
//        label.text = output
//        label.textColor = UIColor.blackColor()
//        view.backgroundColor = UIColor.whiteColor()
//        view.addSubview(label)
//        
//        return view
//    }
    
}
