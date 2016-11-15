//
//  DocumentViewController.swift
//  iTime
//
//  Created by Димас on 7/18/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit
import AVFoundation
import MessageUI

class DocumentViewController: UIViewController, MFMailComposeViewControllerDelegate{
    
    
    @IBOutlet weak var buttonCancel: UIButton!
    @IBAction func buttonCancelAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBOutlet weak var imageViewIcon: UIImageView!
    
    @IBOutlet weak var labelDocumentationText: UILabel!
    
    @IBOutlet weak var buttonTakePicture: UIButton!
    @IBAction func buttonTakePictureAction(sender: UIButton) {
        saveToCamera()
        UIView.animateWithDuration(0.3, animations: {
            self.buttonTakePicture.alpha = 0
            }) { _ in
                self.creatingActionSheet()
        }
    }
    
    @IBOutlet weak var viewForCamera: UIView!
    
    @IBOutlet weak var imageViewForDocument: UIImageView!
    
    var isReport: Bool = false
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        initCamera()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        buttonTakePicture.roundButton()
        buttonTakePicture.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - camera
    var stillImageOutput: AVCaptureStillImageOutput! = AVCaptureStillImageOutput()
    
    var imageTaken: Bool = false
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    var captureDevice : AVCaptureDevice?
    var image_document = UIImage()
    var cameraPreview = UIView()

    
    func saveToCamera() {
        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                let data_image = UIImage(data: imageData)
                
                
                self.image_document = self.cropToBounds(data_image!, width: self.imageViewForDocument.bounds.width, height: self.imageViewForDocument.bounds.height)
                
                self.imageViewForDocument.image = data_image
                
                self.previewLayer?.removeFromSuperlayer()
                self.cameraPreview.removeFromSuperview()
                self.imageTaken = true
                
            }
        } else {
            imageTaken = false
        }
    }
    
    func cropToBounds(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        
        let contextImage: UIImage = UIImage(CGImage: image.CGImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRectMake(posX, posY, cgwidth, cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(CGImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    func initCamera() {
        let devices = AVCaptureDevice.devices().filter{ $0.hasMediaType(AVMediaTypeVideo) && $0.position == AVCaptureDevicePosition.Back }
        if let captureDevice = devices.first as? AVCaptureDevice  {
            if captureSession.inputs.count == 0 {
                do {
                    try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
                } catch {
                    print("use device")
                }
            }
            captureSession.sessionPreset = AVCaptureSessionPresetPhoto
            captureSession.startRunning()
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
            if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
                previewLayer.frame = viewForCamera.bounds
                previewLayer.position = CGPointMake(viewForCamera.bounds.midX, viewForCamera.bounds.midY)
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                cameraPreview = UIView(frame: CGRectMake(0, 0, viewForCamera.bounds.size.width, viewForCamera.bounds.size.height))
                cameraPreview.layer.addSublayer(previewLayer)
                viewForCamera.addSubview(cameraPreview)
                
                viewForCamera.bringSubviewToFront(buttonTakePicture)
                viewForCamera.bringSubviewToFront(imageViewIcon)
                viewForCamera.bringSubviewToFront(labelDocumentationText)
                self.buttonTakePicture.hidden = false
                
                timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(hideText), userInfo: nil, repeats: false)
            }
        } else {
            print("use device")
        }
    }

    var timer: NSTimer?
    func hideText() {
        self.labelDocumentationText.alpha = 0
        self.imageViewIcon.alpha = 0
        timer?.invalidate()
        timer = nil
    }
    
    func saveIncident(){
        
    }

    //MARK: - sheetcontrol
    func creatingActionSheet() {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)

        if isReport {
            
            let addPicture = UIAlertAction(title: "Submit incident", style: .Default, handler: { (action: UIAlertAction) in
                self.sendMail("")
//                self.saveIncident()
            })
            optionMenu.addAction(addPicture)
            
        } else {
            let save = UIAlertAction(title: "Save evidence", style: .Default) { (alert: UIAlertAction!) -> Void in
                print("send image to server and segue after")
                self.navigationController?.popViewControllerAnimated(true)
            }
            
            optionMenu.addAction(save)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (alert: UIAlertAction!) -> Void in
            print("Cancel")
            self.initCamera()
            self.buttonTakePicture.alpha = 1
            
        }
        optionMenu.addAction(cancel)

        self.presentViewController(optionMenu, animated: true, completion: nil)

    }

    
    //MARK: - menu delegate
    func sendMail(sender: AnyObject) {
        
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = configuredMailComposeViewController()
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    //MARK: - mail funcs
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.addAttachmentData(UIImageJPEGRepresentation(self.imageViewForDocument.image!, CGFloat(1.0))!, mimeType: "image/jpeg", fileName:  "test.jpeg")
        mailComposerVC.setToRecipients(["report@itime.com"])
        mailComposerVC.setSubject("Report")
        mailComposerVC.setMessageBody("I'm reporting an accident at ", isHTML: false)
        
        return mailComposerVC
    }
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: {
            self.performSelector(#selector(self.popViewController(_:)), withObject: nil, afterDelay: 0.1)
        })
        
    }
    
    func popViewController(sender: AnyObject) -> Void {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
