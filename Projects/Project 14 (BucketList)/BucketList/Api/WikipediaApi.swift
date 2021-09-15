//
//  WikipediaApi.swift
//  VisitedPlaces
//
//  Created by Alexey Chuvagin on 12.09.2021.
//

import Foundation

class WikipediaApi {
    static var shared = WikipediaApi()
    
    func fetchNearbyPlaces(longitude: Double, latitude: Double, onSuccess: @escaping ([Page]) -> Void, onError: @escaping (String) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "en.wikipedia.org"
        urlComponents.path = "/w/api.php"
        urlComponents.queryItems = [
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "prop", value: "coordinates|pageimages|pageterms"),
            URLQueryItem(name: "list", value: "geosearch"),
            URLQueryItem(name: "gscoord", value: "\(latitude)|\(longitude)"),
            URLQueryItem(name: "gslimit", value: "10"),
            URLQueryItem(name: "gsradius", value: "10000"),
        ]
        
        guard let url = urlComponents.url else {
            onError("Bad URL.")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    onError(error.localizedDescription)
                }
                return
            }
            
            var pages: [Page]?
            
            if let data = data {
                // we got some data back!
                let decoder = JSONDecoder()
                
                if let items = try? decoder.decode(Result.self, from: data) {
                    pages = items.query.geosearch.sorted();
                }
            }

            DispatchQueue.main.async {
                onSuccess(pages ?? [])
            }
        }.resume()
    }
}
