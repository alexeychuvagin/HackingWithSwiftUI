//
//  ProspectsRepository.swift
//  HotProspects
//
//  Created by Alexey Chuvagin on 29.09.2021.
//

protocol ProspectsRepository {
    func fetchAll() -> [Prospect]
    func saveAll(_ prospects: [Prospect])
}
