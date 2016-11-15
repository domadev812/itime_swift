//
//  PhotoForProfileViewController.swift
//  iTime
//
//  Created by Димас on 6/9/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit

class PhotoForProfileViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    @IBOutlet weak var buttonTakePhoto: UIButton!
    @IBOutlet weak var buttonChoosePhoto: UIButton!
    
    
    
    @IBAction func buttonBackAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    let photoPicker = UIImagePickerController()
    var chosenImage:UIImage?
    var imagePicked: Bool?

    @IBOutlet weak var buttonCamera: UIButton!
    @IBAction func buttonCameraAction(sender: UIButton) {
        creatingActionSheet()
    }
    
    
    //Append
    @IBAction func buttonTakePhotoAction(sender: UIButton) {
        
        print("take")
        self.photoPicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.photoPicker.cameraCaptureMode = .Photo
        NSNotificationCenter.defaultCenter().postNotificationName("openCamera", object: nil)
        
    }
    
    @IBAction func buttonChoosePhotoAction(sender: UIButton) {
        
        print("CHoose photo")
        self.photoPicker.sourceType = .PhotoLibrary
        NSNotificationCenter.defaultCenter().postNotificationName("openCamera", object: nil)
        
    }
    //Append end
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoPicker.delegate = self
        photoPicker.allowsEditing = false
        
        photoPicker.modalPresentationStyle = .FullScreen
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(move), name: "go", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(error), name: "stop", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(openCamera), name: "openCamera", object: nil)
        /*
        //Append
        creatingActionSheet()
         */
        
        buttonTakePhoto.roundButton()
        buttonChoosePhoto.roundButton()
        
        
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func move() {
        segue("confirm")
    }
    func error() {
        displayAlert("Image picking fail.", error: "Try again or pick another image")
        //displayMyAlert("Image picking fail.", error: "Try again or pick another image")
    }
    func openCamera() {
        presentViewController(photoPicker, animated: true, completion: nil)
    }
    //MARK: - UIImgeickerViewDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        var imagePicked = false
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            Manager.registerPhoto = image
            imagePicked = true
        } else {
            imagePicked = false
        }
        dismissViewControllerAnimated(true, completion: {
            if imagePicked {
                NSNotificationCenter.defaultCenter().postNotificationName("go", object: nil)
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName("stop", object: nil)
            }
        })
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: {
            NSNotificationCenter.defaultCenter().postNotificationName("stop", object: nil)
        })
        
    }

    //MARK: - ActionSheet func
    func creatingActionSheet() {
        let camera = UIAlertAction(title: "Take photo", style: .Default) { (alert: UIAlertAction!) -> Void in
            print("take")
            self.photoPicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.photoPicker.cameraCaptureMode = .Photo
            NSNotificationCenter.defaultCenter().postNotificationName("openCamera", object: nil)
            
            
        }
        let library = UIAlertAction(title: "Choose Photo", style: .Default) { (alert: UIAlertAction!) -> Void in
            print("CHoose photo")
            self.photoPicker.sourceType = .PhotoLibrary
            NSNotificationCenter.defaultCenter().postNotificationName("openCamera", object: nil)
        }
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        optionMenu.addAction(camera)
        optionMenu.addAction(library)
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
 
    //Append
    func displayMyAlert(title:String, error:String) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in self.okPressed()
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func okPressed() {
        creatingActionSheet()
    }

}
