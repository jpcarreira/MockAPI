//
//  Api.swift
//  MockAPI
//
//  Created by João Carreira on 25/06/2019.
//  Copyright © 2019 João Carreira. All rights reserved.
//

import Foundation


protocol Api {
    
    func fetchMovies(completion: @escaping (Bool, FilmsData?) -> Void)
}


final class ApiClient: Api {
    
    func fetchMovies(completion: @escaping (Bool, FilmsData?) -> Void) {
        HTTPClient.get(from: URL(string: "https://swapi.co/api/films")!) { (json, error) in
            if error == nil {
                do {
                    let data = try JSONSerialization.data(withJSONObject: json as Any, options: [])
                    if let string = String(data: data, encoding: String.Encoding.utf8)?.data(using: .utf8) {
                        let filmsData = try JSONDecoder().decode(FilmsData.self, from: string)
                        completion(true, filmsData)
                    }
                } catch {
                    completion(false, nil)
                }
            }
        }
    }
}


final class MockApiClient: Api {
    
    func fetchMovies(completion: @escaping (Bool, FilmsData?) -> Void) {
       
    }
}


struct Film: Decodable {

    var title: String
    var opening: String
    var director: String
    var releaseDate: String

    enum CodingKeys: String, CodingKey {
        case title
        case opening = "opening_crawl"
        case director
        case releaseDate = "release_date"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        opening = try container.decode(String.self, forKey: .opening)
        director = try container.decode(String.self, forKey: .director)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
    }
}


struct FilmsData: Decodable {
    
    var count: Int
    var results: [Film]
    
    enum CodingKeys: String, CodingKey {
        case count
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        count = try container.decode(Int.self, forKey: .count)
        results = try container.decode(Array.self, forKey: .results)
    }
}
