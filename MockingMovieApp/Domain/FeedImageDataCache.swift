//
//  FeedImageDataCache.swift
//  MockingMovieApp
//
//  Created by Tan Tan on 8/11/22.
//

import Foundation

protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL, completion: @escaping (Result<Void, Error>) -> Void)
}

protocol FeedImageDataStore {
    func insert(_ data: Data, for url: URL, completion: @escaping (Result<Void, Error>) -> Void)
    func retrieve(dataForURL url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}
