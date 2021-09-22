//
//  AddAcquaintanceViewModel.swift
//  Acquaintances
//
//  Created by Alexey Chuvagin on 21.09.2021.
//

import Combine
import CoreLocation
import Foundation
import Resolver
import SwiftUI


class AddAcquaintanceViewModel: ObservableObject {
    private var cancelables = Set<AnyCancellable>()
    
    @Injected private var repository: AcquaintancesRepository

    @Published var name = ""
    @Published var notes = ""
    @Published var location: CLLocationCoordinate2D? = nil
    @Published var saved = false
    
    var image: Image
    
    init(image: Image) {
        self.image = image
    }
    
    func save() {
        repository.save(Acquaintance(id: UUID(), name: self.name, notes: self.notes, location: self.location, image: self.image))
            .receive(on: DispatchQueue.main)
            .map({ _ in true })
            .replaceError(with: false)
            .assign(to: \.saved, on: self)
            .store(in: &cancelables)
    }
    
    deinit {
        for cancelable in cancelables {
            cancelable.cancel()
        }
    }
}
