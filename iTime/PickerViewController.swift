//
//  ViewController.swift
//  iTime
//
//  Created by Димас on 6/7/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, PickerViewDataSource, PickerViewDelegate {
    
    
    @IBAction func buttonBackAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    @IBOutlet weak var pickerView: PickerView!
    
    @IBOutlet weak var buttonUp: UIButton!
    @IBAction func buttonUpAction(sender: UIButton) {
        pickerView.moveUp()
    }
    
    @IBOutlet weak var buttonDown: UIButton!
    @IBAction func buttonDownAction(sender: UIButton) {
        pickerView.moveDown()
    }
    
    @IBOutlet weak var buttonNext: UIButton!
    @IBAction func buttonNextAction(sender: UIButton) {
        segue("photoReg")
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        buttonNext.roundButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonNext.enabled = false
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let scrollingStyle: PickerView.ScrollingStyle = .Default
        let selectionStyle: PickerView.SelectionStyle = .Overlay
        
        pickerView.scrollingStyle = scrollingStyle
        pickerView.selectionStyle = selectionStyle
        
        // Do any additional setup after loading the view, typically from a nib.
        
        pickerView.selectRow(2, animated: true);
    }

    
    let arrPickerView = ["Local Government/Concils", "Welfare and Care Homeles", "Constructions/Civil Engineering", "Railways/Infrastructure", "Hospitals/Medical", "Security"]
    let imageArray = ["LocalGoverment", "Welfare", "Constructions", "Railway", "Hospitals", "Security"]
    
    //MARK: - picker view datasource
    func pickerViewNumberOfRows(pickerView: PickerView) -> Int {
        return arrPickerView.count
    }
    func pickerView(pickerView: PickerView, titleForRow row: Int, index: Int) -> String {
        return " 1 "
    }
    
    //MARK: - pickerview delegate
    func pickerViewHeightForRows(pickerView: PickerView) -> CGFloat {
        return 50
    }
    
    func pickerView(pickerView: PickerView, didSelectRow row: Int, index: Int) {
        print("job profile = \(arrPickerView[index])")
        self.buttonNext.enabled = true
        Manager.registerParams["site"] = "1"; //arrPickerView[index]
    }

    func pickerView(pickerView: PickerView, viewForRow row: Int, index: Int, highlighted: Bool, reusingView view: UIView?) -> UIView? {
        
        var customView: ReusableView

        if view == nil {
        
        // Verify if there is a view to reuse, if not, init your view.
            // Init your view
            var frame = pickerView.frame
            frame.origin = CGPointZero
            frame.size.height = 50
            customView = ReusableView(frame: frame)
            
        customView.labelProf.text = arrPickerView[index]
        customView.imageViewProf.image = UIImage(named: imageArray[index])
        }
        else {
            return view
        }

        
        return customView
    }
}

