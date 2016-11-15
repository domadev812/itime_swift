//
//  QRViewController.swift
//  iTime
//
//  Created by Димас on 6/11/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBAction func buttonCancelAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    @IBOutlet weak var viewCamera: UIView!
    
    @IBOutlet weak var viewVerify: UIView!
    
    @IBOutlet weak var buttonScanQR: UIButton!
    @IBAction func buttonScanQRAction(sender: UIButton) {
        Manager.checkinParams["qr"] = QR_TO_SEND
        self.segue("QRCheck")
    }
    
    @IBOutlet weak var buttonYes: UIButton!
    
    @IBAction func buttonYesAction(sender: UIButton) {
        let params = [
            "user_id": Manager.user_id,
            "qr": QR_TO_SEND
        ]
        if QR_TO_SEND != "" {
            Manager.sharedInstance.checkin(self, type: .QRCode, params: params as! [String: AnyObject], selfie: nil, result: { (result) in
                print("checkined")
                if result {
                    self.segue("QRCheck")
                }
            })
        } else {
            displayAlert("No qr readed", error: "Try again")
        }
    }
    
    @IBOutlet weak var buttonNo: UIButton!
    @IBAction func buttonNoAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    var QR_TO_SEND = ""
    
    
    //MARK: - QR reader instalation 
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewVerify.cornerRadius(8)
        viewVerify.addShadow()
        buttonScanQR.roundButton()
        buttonScanQR.setTitle("Scan QR Code", forState: .Normal)
        buttonScanQR.backgroundColor = UIColor.lightGrayColor()
        //MARK: - testing kill it later
        //self.buttonScanQR.enabled = true
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        cameraInit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func cameraInit() {
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            
            // Detect all the supported bar code
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = viewCamera.layer.bounds
            viewCamera.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture
            captureSession?.startRunning()
            
            // Move the message label to the top view
            // view.bringSubviewToFront(messageLabel)
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.greenColor().CGColor
                qrCodeFrameView.layer.borderWidth = 2
                viewCamera.addSubview(qrCodeFrameView)
                viewCamera.bringSubviewToFront(qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        

    }

    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            //QRText.text = "No barcode/QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if supportedBarCodes.contains(metadataObj.type) {
            // if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                //QRText.text = metadataObj.stringValue
                self.buttonScanQR.enabled = true
                self.buttonScanQR.setTitle("Send QR", forState: .Normal)
                self.buttonScanQR.backgroundColor = UIColor.redColor()
                QR_TO_SEND = metadataObj.stringValue
            }
        }
    }
}
