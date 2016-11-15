
import UIKit

class SettingsCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var switchNotification: UISwitch!
    
}

class SettingsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var backButton: UIButton!
    @IBAction func buttonBackAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logOut(){
        Manager.sharedInstance.removeUserFromDefaults()
        if let nav = self.navigationController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let main = storyboard.instantiateViewControllerWithIdentifier(loginControllerName)
            nav.setViewControllers([main], animated: true)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
//            return 3
            return 1
        }else {
            return 0
        }
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "NOTIFICATIONS"
        }else if section == 1 {
            return " "
        }else {
            return ""
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell", forIndexPath: indexPath) as! SettingsCell
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.switchNotification.hidden = false
                cell.lblName?.text = "SHOW NOTIFICATIONS"
            }
        }
        if indexPath.section == 1 {
            cell.switchNotification.hidden = true
//            if indexPath.row == 0 {
//                cell.lblName?.text = "PRIVACY POLICY"
//                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//            }
//            if indexPath.row == 1 {
//                cell.lblName?.text = "TERMS OF SERVICE"
//                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//            }
            if indexPath.row == 0 {
                cell.lblName?.text = "LOG OUT"
            }
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1 && indexPath.row == 0 {
            logOut()
        }
    }
    
}
