//
//  FilterType.swift
//  HotProspects
//
//  Created by Alexey Chuvagin on 28.09.2021.
//

enum FilterType {
    case none, contacted, uncontacted
}

extension FilterType {
    var description : String {
        switch self {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
}
