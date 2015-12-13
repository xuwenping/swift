//
//  FirstViewController.swift
//  MyLocations
//
//  Created by devinxu on 12/10/15.
//  Copyright © 2015 devinxu. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController,
                                            CLLocationManagerDelegate {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudelabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    var location: CLLocation?
    
    var updatingLocation = true
    var lastLocationError: NSError?
    
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReversegeocoding = false
    var lastGeocodingError: NSError?
    
    
    @IBAction func getLocation()
    {
        let authStatus: CLAuthorizationStatus =
                            CLLocationManager.authorizationStatus()
        if authStatus == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .Denied || authStatus == .Restricted
        {
            showLocationServicesDeniedAlert()
            return
        }
        
        //startLocationManager()
        if updatingLocation {
            stopLocationManager()
        }
        else {
            location = nil
            lastLocationError = nil
            placemark = nil
            lastGeocodingError = nil
            startLocationManager()
        }
        
        updateLabels()
        configureGetButton()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        updateLabels()
        configureGetButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showLocationServicesDeniedAlert()
    {
        let alert = UIAlertController(title: "location service disabled",
            message: "Please enable location services for this app in Settings.",
            preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alert.addAction(okAction)
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func updateLabels()
    {
        if let location = location {
            latitudeLabel.text =
                String(format: "%.8f", location.coordinate.latitude)
            longitudelabel.text =
                String(format: "%.8f", location.coordinate.longitude)
            tagButton.hidden = false
            messageLabel.text = ""
            
            if let placemark = placemark {
                addressLabel.text = stringFromPlacemark(placemark)
            }
            else if performingReversegeocoding {
                addressLabel.text = "Searching for Address..."
            }
            else if lastGeocodingError != nil {
                addressLabel.text = "Error Finding Address"
            }
            else {
                addressLabel.text = "No Address Found"
            }
        }
        else {
            latitudeLabel.text = ""
            longitudelabel.text = ""
            addressLabel.text = ""
            tagButton.hidden = true
            //messageLabel.text = "Tap 'Get My Location' to start"
            
            // The new code starts here:
            var statusMessage: String
            if let error = lastLocationError {
                if error.domain == kCLErrorDomain
                    && error.code == CLError.Denied.rawValue {
                    statusMessage = "Location Services Disabled"
                }
                else {
                    statusMessage = "Error Getting Location"
                }
            }
            else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Services Disabled"
            }
            else if updatingLocation {
                statusMessage = "Searching"
            }
            else {
                statusMessage = "Tap 'Get My Location' to start"
            }
            
            messageLabel.text = statusMessage
         }
    }
    
    func stopLocationManager()
    {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
    
    func startLocationManager()
    {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy =
                                        kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    }
    
    func configureGetButton()
    {
        if updatingLocation {
            getButton.setTitle("Stop", forState: .Normal)
        }
        else {
            getButton.setTitle("Get My Location", forState: .Normal)
        }
    }
    
    func stringFromPlacemark(placemark: CLPlacemark) -> String {
        return
            "\(placemark.subThoroughfare) \(placemark.thoroughfare)\n" +
            "\(placemark.locality) \(placemark.administrativeArea) " +
            "\(placemark.postalCode)"
    }

    // MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWithError \(error)")
        
        if error.code == CLError.LocationUnknown.rawValue {
            return
        }
        
        lastLocationError = error
        
        stopLocationManager()
        updateLabels()
        configureGetButton()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last! as CLLocation
        print("didUpdateLocations \(newLocation)")
        
        //1
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        
        //2 
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        //3
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil
            location = newLocation
            updateLabels()
            
            //5
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("*** We're done!")
                stopLocationManager()
                configureGetButton()
            }
            
            if !performingReversegeocoding {
                print("*** Going to geocode")
                
                performingReversegeocoding = true
                
                geocoder.reverseGeocodeLocation(location!, completionHandler: {
                    placemarks, error in
                    print("*** Found placemarks: \(placemarks), error:\(error)")
                    
                    self.lastGeocodingError = error
                    if error == nil && !placemarks!.isEmpty {
                        self.placemark = placemarks!.last! as CLPlacemark
                    }
                    else {
                        self.placemark = nil
                    }
                    
                    self.performingReversegeocoding = false
                    self.updateLabels()
                })
            }
        }

    }
    
}

