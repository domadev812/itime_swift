//
//  MapViewController.swift
//  iTime
//
//  Created by Димас on 6/10/16.
//  Copyright © 2016 Димас. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: BaseViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var manager:CLLocationManager!
    
    var lat:CLLocationDegrees?
    
    var lon:CLLocationDegrees?
    
    var selfieToSend: UIImage?

    
    @IBOutlet weak var buttonClear: UIButton!
    @IBAction func buttonClearAction(sender: UIButton) {
    }
    
    @IBOutlet weak var textFieldSearch: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var viewVerify: UIView!
    
    @IBOutlet weak var buttonYes: UIButton!
    @IBAction func buttonYesAction(sender: UIButton) {
        if let strLat = lat {
            if let strLon = lon {
                Manager.checkinParams["lat"] = String(strLat)
                Manager.checkinParams["lon"] = String(strLon)
                print(String(lat!))
                print(String(lon!))
            }
        }
        self.showActivity()
        
        if isCheckout {
            isCheckout = false
            
            Manager.sharedInstance.checkout(self, onComp: { (bool) in
                if bool {
                    //            self.segue("checkoutSegue")
                    self.segue("ShiftCompleted")
                }
            })
        } else {
           // Manager.checkinParams["user_id"] = Manager.user_id;
            Manager.sharedInstance.checkin(self, selfie: selfieToSend, onComp: { (result) in
                self.hideActivity()
                if result {
                    self.segue("MapCheck")
                } else {
                    self.displayAlert("Something went wrong", error: "")
                }
            })
        }
    }
    
    @IBOutlet weak var buttonNo: UIButton!
    @IBAction func buttonNoAction(sender: UIButton) {
        alertWithReason { message in
            print("do with this message anything")
            print("message = \(message)")
            print("checkin params = \(Manager.checkinParams)")
            Manager.checkinParams["lat"] = ""
            Manager.checkinParams["lon"] = ""
            //self.segue("MapCheck")
            self.showActivity()
            if isCheckout {
                isCheckout = false
                
                Manager.sharedInstance.checkout(self, onComp: { (bool) in
                    if bool {
                        //            self.segue("checkoutSegue")
                        self.segue("ShiftCompleted")
                    }
                })
            }else {
                Manager.sharedInstance.checkin(self, selfie: self.selfieToSend, onComp: { (result) in
                    self.hideActivity()
                    if result {
                        if isCheckout {
                            isCheckout = false
                            self.segue("ShiftCompleted")
                        } else {
                            Manager.locationController.startUpdating()
                            self.segue("MapCheck")
                        }
                    } else {
                        self.displayAlert("Something went wrong", error: "")
                    }
                })
            }
        }
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        manager.stopUpdatingLocation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        viewVerify.cornerRadius(8)
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        view.bringSubviewToFront(viewVerify)
        view.bringSubviewToFront(buttonClear)
        view.bringSubviewToFront(textFieldSearch)
        viewVerify.layer.borderWidth = 1
        viewVerify.layer.borderColor = UIColor.blackColor().CGColor
        viewVerify.addShadow()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Core Location
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        //manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        
        let latitude:CLLocationDegrees = userLocation.coordinate.latitude
        
        let longitude:CLLocationDegrees = userLocation.coordinate.longitude
        
        let latDelta:CLLocationDegrees = 0.01
        
        let lonDelta:CLLocationDegrees = 0.01
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        mapView.setRegion(region, animated: true)
        lat = userLocation.coordinate.latitude
        lon = userLocation.coordinate.longitude
        print("LONGITUDE: \(lon!)      LATITUDE: \(lat!)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func mapView(mapView: MKMapView,
                 viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
            
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.image = UIImage(named:"MapPin")!
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
}
