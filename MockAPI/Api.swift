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
    
    private static let delay = 4
    
    func fetchMovies(completion: @escaping (Bool, FilmsData?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(MockApiClient.delay)) {
            let filePath = "films"
            MockApiClient.loadJsonDataFromFile(filePath, completion: { data in
                if let json = data {
                    do {
                        let estimate = try JSONDecoder().decode(FilmsData.self, from: json)
                        completion(true, estimate)
                    }
                    catch _ as NSError {
                        fatalError("Couldn't load data from \(filePath)")
                    }
                }
            })
        }
    }
    
    private static func loadJsonDataFromFile(_ path: String, completion: (Data?) -> Void) {
        if let fileUrl = Bundle.main.url(forResource: path, withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileUrl, options: [])
                completion(data as Data)
            } catch (let error) {
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
}
