//
//  UserDefaultsProspectsRepository.swift
//  HotProspects
//
//  Created by Alexey Chuvagin on 29.09.2021.
//

import Foundation

/// https://www.hackingwithswift.com/read/12/2/reading-and-writing-basics-userdefaults
class UserDefaultsProspectsRepository: ProspectsRepository {
    static let shared = UserDefaultsProspectsRepository()
    private static let saveKey = "SavedData"
    
    func fetchAll() -> [Prospect] {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                return decoded
            }
        }
        
        return []
    }
    
    func saveAll(_ prospects: [Prospect]) {
        if let encoded = try? JSONEncoder().encode(prospects) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
}
