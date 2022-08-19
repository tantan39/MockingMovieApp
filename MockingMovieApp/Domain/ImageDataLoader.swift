//
//  ImageDataLoader.swift
//  MockingMovieApp
//
//  Created by Tan Tan on 8/17/22.
//

import Foundation

protocol ImageDataLoaderTask {
    func cancel()
}

protocol ImageDataLoader {
    func loadImageData(url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> ImageDataLoaderTask
}
