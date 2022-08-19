//
//  APIService.swift
//  MockingMovieApp
//
//  Created by Tan Tan on 8/10/22.
//

import Foundation

protocol HTTPClient {
    func get(url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void)
}

enum APIError: Error {
    case connectionError
    case invalidData
}

class APIService: FeedLoader {
    init(client: HTTPClient) {
        self.client = client
    }
    
    let client: HTTPClient
    
    struct Root: Decodable {
        let page: Int
        let results: [Movie]
    }
    
    func fetchMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: Endpoints.movies(page: page).url) else { return }
        client.get(url: url) { response in
            switch response {
            case .success((let data, _)):
                if let root = try? JSONDecoder().decode(Root.self, from: data) {
                    completion(.success(root.results))
                } else {
                    completion(.failure(APIError.invalidData))
                }
            case .failure:
                completion(.failure(APIError.connectionError))
            }
        }
    }
}

extension APIService: ImageDataLoader {
    func loadImageData(url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> ImageDataLoaderTask {
        let task = URLSessionTaskWrapper()
        print("Loading image \(url.absoluteString)")
        task.wrapper = URLSession(configuration: .default).dataTask(with: url, completionHandler: { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(APIError.connectionError))
            }
        })
        task.wrapper?.resume()
        
        return task
    }
}

class URLSessionTaskWrapper: ImageDataLoaderTask {
    var wrapper: URLSessionDataTask?
    
    func cancel() {
        wrapper?.cancel()
        wrapper = nil
    }
}
