//
//  MyLocationManager.swift
//  ios-treasure
//
//  Created by Mario Holper on 13.10.19.
//  Copyright © 2019 Mario Holper. All rights reserved.
//

import CoreLocation

class MyLocationManager: NSObject, CLLocationManagerDelegate {
    
//Zugriff auf gemeinsame Instanz von MyLocationManager
    static let shareInstance = MyLocationManager()
    
    //Referenz auf den Location Manager
    var locmgr = CLLocationManager()
    //bequemer Zugriff auf die letzte Position enthält Daten sobald locationManager(..., didUpdateLocation)
    //zum ersten Mal aufgerufen wird
    var location:CLLocation!
    var heading: CLHeading!

    //Location Manager initialisieren
    override init() {
        super.init()
        locmgr.delegate = self
        locmgr.desiredAccuracy = kCLLocationAccuracyBest
        
    //um Erlaunis fragen
        locmgr.requestWhenInUseAuthorization()
    
    //Location- und Heading-Ereignisse verarbeiten
        locmgr.startUpdatingLocation()
        locmgr.startUpdatingHeading()
    }
    
    //didUpdateLocation-Delegation verarbeiten
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locmgr.location
        NotificationCenter.default.post(name: Notification.Name(rawValue: "NewLocation"), object: manager)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = locmgr.heading
        NotificationCenter.default.post(name: Notification.Name(rawValue: "NewHeading"), object: manager)
    }
    
    //bei Bedarf Dialog zur Kompasskalibrierung einblenden
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
}
