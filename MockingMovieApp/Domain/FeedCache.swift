//
//  FeedCace.swift
//  MockingMovieApp
//
//  Created by Tan Tan on 8/18/22.
//

import Foundation

protocol FeedCache {
    func save(_ feed: [Movie], completion: @escaping (Result<Void, Error>) -> Void)
}

protocol FeedStore {
    func insert(_ feed: [Movie], completion: @escaping (Result<Void, Error>) -> Void)
    func retrieve(completion: @escaping (Result<[Movie], Error>) -> Void)
}
