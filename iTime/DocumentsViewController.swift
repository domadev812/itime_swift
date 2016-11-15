//
//  DocumentsViewController.swift
//  iTime
//
//  Created by Димас on 7/31/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit

class DocumentCell: UITableViewCell {
    
    @IBOutlet weak var labelDocumentName: UILabel!
    
    @IBOutlet weak var labelDocumentType: UILabel!
    
    @IBOutlet weak var labelDocumentTimeAgo: UILabel!
    
}

class DocumentsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var backButton: UIButton!
    @IBAction func buttonBackAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    var data = DocumentModel?()
    var documents = [Document]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showActivity()
        Manager.sharedInstance.getDocuments { (datas) in
            self.hideActivity()
            if datas.0 == true {
                self.data = datas.1 as? DocumentModel
                self.documents = (self.data?.data!)!
                self.tableView.reloadData()
            }
        }
    }

    //MARK: - cell configurator
    func configCell(tableView: UITableView, indexPath: NSIndexPath) -> DocumentCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("documentCell", forIndexPath: indexPath) as! DocumentCell
        var secondsFromGMT: Int { return NSTimeZone.localTimeZone().secondsFromGMT }
        
        var name: String?
        var kind: String?
        var modified: String?
        
        name = documents[indexPath.row].name!
        kind = documents[indexPath.row].kind!
        modified = documents[indexPath.row].modified!
        
        cell.labelDocumentName.text = name
        cell.labelDocumentType.text = kind
        cell.labelDocumentTimeAgo.text = modified
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return configCell(tableView, indexPath: indexPath)
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
