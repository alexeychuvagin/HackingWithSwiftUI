//
//  Prospects.swift
//  HotProspects
//
//  Created by Alexey Chuvagin on 28.09.2021.
//

import Foundation
import Combine

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var createdAt = Date()
    fileprivate(set) var isContacted = false
}

class Prospects: ObservableObject {
    private static let saveKey = "SavedData"
    private let repository: ProspectsRepository
    
    @Published private(set) var people: [Prospect]
    
    init(repository: ProspectsRepository) {
        self.repository = repository
        self.people = repository.fetchAll()
    }
    
    func add(_ person: Prospect) {
        people.append(person)
        repository.saveAll(people)
    }
    
    func toggle(_ prospect: Prospect) {
        // Important: You should call objectWillChange.send() before changing your property, to ensure SwiftUI gets its animations correct.
        objectWillChange.send()
        prospect.isContacted.toggle()
        repository.saveAll(people)
    }
}
