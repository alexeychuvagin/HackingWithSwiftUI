//
//  Acquaintance.swift
//  Acquaintances
//
//  Created by Alexey Chuvagin on 17.09.2021.
//

import Foundation
import CoreLocation
import SwiftUI

struct Acquaintance: Identifiable {
    var id: UUID?
    var name: String
    var notes: String
    var location: CLLocationCoordinate2D?
    var image: Image
}

extension Acquaintance {
    static let stub_first = stub_list[0]
    
    static var stub_list = [
        Acquaintance(id: UUID(), name: "Bob Dylan", notes: "Senior iOS Developer", location: CLLocationCoordinate2D(latitude: 51.5, longitude: 0.13), image: Image("profile_1")),
        Acquaintance(id: UUID(), name: "Taylor Swift", notes: "Middle QA", location: CLLocationCoordinate2D(latitude: 50.1960, longitude: 6.8712), image: Image("profile_2")),
        Acquaintance(id: UUID(), name: "Kavin Rodriges", notes: "Senior .NET Developer", image: Image("profile_3")),
    ]
}
