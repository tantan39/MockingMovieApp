//
//  LocalImageDataService.swift
//  MockingMovieApp
//
//  Created by Tan Tan on 8/11/22.
//

import Foundation

class LocalImageDataService: FeedImageDataCache, ImageDataLoader {
    let store: FeedImageDataStore
    
    init(store: FeedImageDataStore) {
        self.store = store
    }
    
    func loadImageData(url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> ImageDataLoaderTask {
        let task = LocalImageDataLoaderTask(completion: completion)
        self.store.retrieve(dataForURL: url, completion: completion)
        return task
    }
    
    func save(_ data: Data, for url: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        self.store.insert(data, for: url, completion: completion)
    }
    
    private class LocalImageDataLoaderTask: ImageDataLoaderTask {
        private var completion: ((Result<Data, Error>) -> Void)?
        
        init(completion: ((Result<Data, Error>) -> Void)?) {
            self.completion = completion
        }
        
        func complete(_ result: (Result<Data, Error>)) {
            self.completion?(result)
        }
        
        func cancel() {
            self.completion = nil
        }
    }
}
