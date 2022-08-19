//
//  URLSessionHTTPClient.swift
//  MockingMovieApp
//
//  Created by Tan Tan on 8/17/22.
//

import Foundation

class URLSessionHTTPClient: HTTPClient {
    let session: URLSession = .init(configuration: .ephemeral)
    
    func get(url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(APIError.connectionError))
            }
        }.resume()
    }
}
