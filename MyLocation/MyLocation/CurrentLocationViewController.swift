//
//  FirstViewController.swift
//  MyLocation
//
//  Created by devinxu on 9/11/15.
//  Copyright (c) 2015 devinxu. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    var location: CLLocation?
    
    var updateLoacation = false
    var lastLocationError: NSError?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        updateLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getLocation() {
        let authStutus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        if authStutus == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
            return;
        }
        
        if authStutus == .Denied || authStutus == .Restricted {
            showLocationServiceDeniedAlert()
            return;
        }
        
        startLocationManager()
        updateLabel()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("didFailWithError \(error)")
        
        // it means the location manager was unable to obtain a location right now
        if error.code == CLError.LocationUnknown.rawValue {
            return
        }
        
        lastLocationError = error
        
        stopLocationManager()
        updateLabel()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let newLocation = locations.last as! CLLocation
        println("didUpdateLocation \(newLocation)")
        
        lastLocationError = nil
        
        location = newLocation
        updateLabel()
    }
    
    func showLocationServiceDeniedAlert() {
        let alert = UIAlertController(title: "Location services Disabled", message: "Please enable location services for the app in Settings.", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alert.addAction(okAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateLabel() {
        if let location = self.location {
            latitudeLabel.text = String(format: "%.8f", self.location!.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", self.location!.coordinate.longitude)
            tagButton.hidden = false
            messageLabel.text = ""
        }
        else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            tagButton.hidden = true
            
            var statusMessage: String
            if let error = lastLocationError {
                if error.domain == kCLErrorDomain && error.code == CLError.Denied.rawValue {
                    statusMessage = "Location Services Disabled"
                }
                else {
                    statusMessage = "Error Getting location"
                }
            }
            else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Service Disabled"
            }
            else if updateLoacation {
                statusMessage = "Searching"
            }
            else {
                statusMessage = "Tap 'Get My Location' to Start"
            }
            
            messageLabel.text = statusMessage
        }
    }
    
    func stopLocationManager() {
        if updateLoacation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updateLoacation = false
        }
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updateLoacation = true
        }
    }
}

