//
//  AcquaintanceDetailsViewModel.swift
//  Acquaintances
//
//  Created by Alexey Chuvagin on 22.09.2021.
//

import Foundation
import MapKit

class AcquaintanceDetailsViewModel: ObservableObject {
    private(set) var acquaintance: Acquaintance
    private(set) var annotations: [MKPointAnnotation] = []
    @Published var state: State = State.details
    
    init(acquaintance: Acquaintance) {
        self.acquaintance = acquaintance
        
        if let location = acquaintance.location {
            let annotation = MKPointAnnotation()
            annotation.title = acquaintance.name
            annotation.subtitle = acquaintance.notes
            annotation.coordinate = location
            
            annotations.append(annotation)
        }
    }
    
    public enum State {
        case details, location
    }
}
