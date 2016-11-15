//
//  SelfieIdentificationViewController.swift
//  iTime
//
//  Created by Димас on 6/11/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit
import AVFoundation


class SelfieIdentificationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var viewCamera: UIView!
    
    @IBOutlet weak var imageViewForSelfie: UIImageView!
    
    
    @IBOutlet weak var imageViewVisualIdentity: UIImageView!
    
    @IBOutlet weak var labelVisualIdentity: UILabel!
    
    @IBOutlet weak var buttonTakeSelfie: UIButton!
    @IBAction func buttonTakeSelfieAction(sender: UIButton) {
        
        saveToCamera()
        //if imageTaken {
        viewVerifySelfie.alpha = 1
        buttonTakeSelfie.alpha = 0
        imageViewVisualIdentity.alpha = 0
        labelVisualIdentity.alpha = 0

       // } else {
         //   self.navigationController?.popViewControllerAnimated(true)
        //}
        
    }
    
    @IBOutlet weak var viewVerifySelfie: UIView!

    @IBOutlet weak var buttonYes: UIButton!
    @IBAction func buttonYesAction(sender: UIButton) {
//        let params: [String: String] = [
//        "user_id": String(Manager.user_id)
//        ]
        if let _ = imageViewForSelfie.image {
//            Manager.sharedInstance.checkin(self, type: .Selfie, params: params, selfie: image) { (result) in
//                print("done")
//                if result {
                    self.segue("selfieCheck")
//                }
//            }

        } else {
            displayAlert("Take image!", error: "No image taken")
        }
    }
    
    @IBOutlet weak var buttonNo: UIButton!
    @IBAction func buttonNoAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    var stillImageOutput: AVCaptureStillImageOutput! = AVCaptureStillImageOutput()
    
    var imageTaken: Bool = false
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    var image_selfie = UIImage()
    
    func saveToCamera() {
        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                //UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData)!, nil, nil, nil)
                let data_image = UIImage(data: imageData)
                
                
                self.image_selfie = self.cropToBounds(data_image!, width: self.imageViewForSelfie.bounds.width, height: self.imageViewForSelfie.bounds.height)
                
                self.imageViewForSelfie.image = data_image
                self.imageViewForSelfie.transform = CGAffineTransformMakeScale(-1, 1)

                    //self.cropToBounds(data_image!, width: self.imageViewForSelfie.bounds.width, height: self.imageViewForSelfie.bounds.height)
                
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
    var cameraPreview = UIView()
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        imageViewVisualIdentity.alpha = 1
        labelVisualIdentity.alpha = 1
        viewVerifySelfie.alpha = 0
        imageViewForSelfie.image = nil
        buttonTakeSelfie.alpha = 1
        buttonTakeSelfie.roundButton()
        viewVerifySelfie.cornerRadius(8)
        viewVerifySelfie.addShadow()
        buttonTakeSelfie.layer.borderWidth = 1
        buttonTakeSelfie.layer.borderColor = UIColor.blackColor().CGColor
        
        buttonTakeSelfie.hidden = true
        
//        buttonTakeSelfie.addShadow(2)
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        initCamera()
        //buttonTakeSelfie.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    func initCamera() {
        let devices = AVCaptureDevice.devices().filter{ $0.hasMediaType(AVMediaTypeVideo) && $0.position == AVCaptureDevicePosition.Front }
        if let captureDevice = devices.first as? AVCaptureDevice  {
            
            do {
                try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
            } catch {
                print("use device")
            }
            captureSession.sessionPreset = AVCaptureSessionPresetPhoto
            captureSession.startRunning()
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
            if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
                previewLayer.frame = viewCamera.bounds
                previewLayer.position = CGPointMake(viewCamera.bounds.midX, viewCamera.bounds.midY)
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                cameraPreview = UIView(frame: CGRectMake(viewCamera.frame.origin.x, viewCamera.frame.origin.y, viewCamera.bounds.size.width, viewCamera.bounds.size.height))
                cameraPreview.layer.addSublayer(previewLayer)
                //cameraPreview.addGestureRecognizer(UITapGestureRecognizer(target: self, action:"saveToCamera:"))
                view.addSubview(cameraPreview)
                
                view.bringSubviewToFront(buttonTakeSelfie)
                view.bringSubviewToFront(viewVerifySelfie)
                view.bringSubviewToFront(imageViewVisualIdentity)
                view.bringSubviewToFront(labelVisualIdentity)
                self.buttonTakeSelfie.hidden = false
                timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(hideText), userInfo: nil, repeats: false)
            }
        } else {
            print("use device")
        }
    }
    var timer: NSTimer?
    func hideText() {
        self.labelVisualIdentity.alpha = 0
        self.imageViewVisualIdentity.alpha = 0
        timer?.invalidate()
        timer = nil
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selfieCheck" {
            let nvc = segue.destinationViewController as! MapViewController
            if let image = imageViewForSelfie.image {
                nvc.selfieToSend = image
            }
        }
    }
    
}
