//
//  DocumentsProspectsRepository.swift
//  HotProspects
//
//  Created by Alexey Chuvagin on 29.09.2021.
//

import Foundation

/// https://www.hackingwithswift.com/books/ios-swiftui/writing-data-to-the-documents-directory
class DocumentsProspectsRepository: ProspectsRepository {
    static let shared = DocumentsProspectsRepository()
    private static let fileName = "SavedData.json"
    
    private func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    func fetchAll() -> [Prospect] {
        let url = getDocumentsDirectory().appendingPathComponent(Self.fileName)
        
        if let data = try? Data(contentsOf: url) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                return decoded
            }
        }
        
        return []
    }
    
    func saveAll(_ prospects: [Prospect]) {
        let url = getDocumentsDirectory().appendingPathComponent(Self.fileName)
        
        if let encoded = try? JSONEncoder().encode(prospects) {
            do {
                try encoded.write(to: url, options: .atomic)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}
