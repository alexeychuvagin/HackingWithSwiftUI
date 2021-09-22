//
//  LocationFetcher.swift
//  Acquaintances
//
//  Created by Alexey Chuvagin on 22.09.2021.
//

import CoreLocation

protocol LocationFetcher {
    func start()
    func stop()
    func getLastKnownLocation() -> CLLocationCoordinate2D?
}
