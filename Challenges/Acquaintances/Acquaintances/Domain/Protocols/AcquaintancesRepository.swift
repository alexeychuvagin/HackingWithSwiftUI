//
//  AcquaintancesRepository.swift
//  Acquaintances
//
//  Created by Alexey Chuvagin on 17.09.2021.
//

import Combine

protocol AcquaintancesRepository {
    func fetchAll() -> AnyPublisher<[Acquaintance], Error>
    func save(_ acquaintance: Acquaintance) -> AnyPublisher<Void, Error>
}
