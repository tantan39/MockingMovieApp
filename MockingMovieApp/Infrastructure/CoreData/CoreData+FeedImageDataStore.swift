//
//  CoreData+FeedImageDataStore.swift
//  MockingMovieApp
//
//  Created by Tan Tan on 8/18/22.
//

import Foundation

extension CoreDataStore: FeedImageDataStore {
    func insert(_ data: Data, for url: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = self.context
        context.perform {
            
            do {
                if let manageMovie = try? ManageMovie.first(with: url, in: context) {
                    manageMovie.data = data
                    print("insert cache success")
                    completion(.success(()))
                    
                } else {
                    let manageMovie = ManageMovie(context: context)
                    manageMovie.data = data
                    manageMovie.url = url
                    completion(.success(()))
                    print("insert cache success")
                }
                try context.save()
            } catch (let error) {
                print("insert cache failed")
                completion(.failure(error))
            }
            
        }
    }
    
    func retrieve(dataForURL url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let context = context
        context.perform {
            do {
                if let data = try ManageMovie.data(with: url, in: context) {
                    completion(.success(data))
                    try context.save()
                } else {
                    completion(.failure(StoreError.modelNotFound))
                }
            } catch (let error) {
                completion(.failure(error))
            }

        }
    }
}
