//
//  FilmData.swift
//  MockAPI
//
//  Created by João Carreira on 26/06/2019.
//  Copyright © 2019 João Carreira. All rights reserved.
//

import Foundation


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


struct Film: Decodable {
    
    var title: String
    var director: String
    var releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case director
        case releaseDate = "release_date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        director = try container.decode(String.self, forKey: .director)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
    }
}
