//
//  DeviceLocationFetcher.swift
//  Acquaintances
//
//  Created by Alexey Chuvagin on 21.09.2021.
//

import CoreLocation

class DeviceLocationFetcher: NSObject, CLLocationManagerDelegate, LocationFetcher {
    let manager = CLLocationManager()
    private var lastKnownLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func stop() {
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
    
    func getLastKnownLocation() -> CLLocationCoordinate2D? {
        lastKnownLocation
    }
}
