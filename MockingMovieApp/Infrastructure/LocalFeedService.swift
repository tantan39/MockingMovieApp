//
//  LocalFeedService.swift
//  MockingMovieApp
//
//  Created by Tan Tan on 8/18/22.
//

import Foundation

class LocalFeedService: FeedCache {
    
    private let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
    
    func save(_ feed: [Movie], completion: @escaping (Result<Void, Error>) -> Void) {
        store.insert(feed, completion: completion)
    }
}

extension LocalFeedService: FeedLoader {
    func fetchMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        store.retrieve(completion: completion)
    }
}
