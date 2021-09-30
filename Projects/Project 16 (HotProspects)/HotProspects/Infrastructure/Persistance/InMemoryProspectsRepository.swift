//
//  InMemoryProspectsRepository.swift
//  HotProspects
//
//  Created by Alexey Chuvagin on 29.09.2021.
//

import Foundation

/// https://www.hackingwithswift.com/books/ios-swiftui/writing-data-to-the-documents-directory
class InMemoryProspectsRepository: ProspectsRepository {
    static let shared = InMemoryProspectsRepository()
    private(set) var people: [Prospect]
    
    init() {
        let person1 = Prospect()
        person1.emailAddress = "test1@gmail.com"
        person1.name = "Zy Maties"
        
        let person2 = Prospect()
        person2.emailAddress = "test2@gmail.com"
        person2.name = "Alex Brown"
        
        people = [person1, person2]
    }
    
    func fetchAll() -> [Prospect] {
        return people
    }
    
    func saveAll(_ prospects: [Prospect]) {
        people = prospects
    }
}
