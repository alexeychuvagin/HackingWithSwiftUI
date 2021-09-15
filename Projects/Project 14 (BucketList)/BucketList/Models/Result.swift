import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let geosearch: [Page]
}

struct Page: Codable, Comparable {
    enum CodingKeys: String, CodingKey {
        case pageId = "pageid"
        case title
    }
    
    let pageId: Int
    let title: String
    
    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}
