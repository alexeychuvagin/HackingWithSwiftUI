//
//  AcquaintancesInMemoryRepository.swift
//  Acquaintances
//
//  Created by Alexey Chuvagin on 17.09.2021.
//

import Foundation
import Combine
import SwiftUI
import CoreLocation

class AcquaintancesInMemoryRepository: AcquaintancesRepository  {
    private var acquaintances = Array<Acquaintance>()

    init() {
        self.acquaintances.append(contentsOf: Acquaintance.stub_list)
    }
    
    func fetchAll() -> AnyPublisher<[Acquaintance], Error> {
        return Just(acquaintances)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func save(_ acquaintance: Acquaintance) -> AnyPublisher<Void, Error> {
        var newAcquaintance = acquaintance;
        newAcquaintance.id = UUID()
        acquaintances.append(newAcquaintance)

        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
