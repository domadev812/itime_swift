//
//  BaseViewController.swift
//  iTime
//
//  Created by Димас on 7/31/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var activity: UIView?
    func showActivity() {
        AsyncHelper.showActivityIndicator(&activity, containerView: self.view)
    }
    func hideActivity() {
        AsyncHelper.hideActivityIndicator(self.activity, containerView: self.view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initControllerWithName(storyBoardID: String) {
        let current_storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = current_storyboard.instantiateViewControllerWithIdentifier(storyBoardID)
        self.navigationController?.pushViewController(newVC, animated: true)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
