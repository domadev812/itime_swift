//
//  ReusableView.swift
//  iTime
//
//  Created by Димас on 6/7/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit

class ReusableView: UIView {

    @IBOutlet weak var imageViewProf: UIImageView!
    
    @IBOutlet weak var labelProf: UILabel!
    
    @IBOutlet var embeddedView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        backgroundColor = .clearColor()
        
        embeddedView = loadViewFromNib()
        embeddedView.frame = bounds
        embeddedView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        embeddedView.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(embeddedView)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: String(self.dynamicType), bundle: bundle)
        let nibView = nib.instantiateWithOwner(self, options: nil).first as! UIView
        
        return nibView
    }
}
