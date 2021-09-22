//
//  AcquaintancesListViewModel.swift
//  Acquaintances
//
//  Created by Alexey Chuvagin on 21.09.2021.
//

import Combine
import Resolver
import SwiftUI

class AcquaintancesListViewModel: ObservableObject {
    @Injected private var repository: AcquaintancesRepository
    
    @Published private(set) var acquaintances: [Acquaintance] = []
    @Published var showingImagePicker = false
    @Published var showingCreateAcquaintance = false
    
    private var cancelables = Set<AnyCancellable>()
    
    var image: Image?
    
    func refresh() {
        repository.fetchAll()
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.acquaintances, on: self)
            .store(in: &cancelables)
    }
    
    deinit {
        for cancelable in cancelables {
            cancelable.cancel()
        }
    }
}
