//
//  FeedLoader.swift
//  MockingMovieApp
//
//  Created by Tan Tan on 8/10/22.
//

import Foundation

protocol FeedLoader {
    func fetchMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void)
}
