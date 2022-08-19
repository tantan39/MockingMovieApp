//
//  CoreData+FeedStore.swift
//  MockingMovieApp
//
//  Created by Tan Tan on 8/18/22.
//

import CoreData

extension CoreDataStore: FeedStore {
    func insert(_ feed: [Movie], completion: @escaping (Result<Void, Error>) -> Void) {
        let context = self.context
        context.perform {
            do {
                for movie in feed {
                    let manageMovie = ManageMovie(context: context)
                    manageMovie.id = Int32(movie.id)
                    manageMovie.title = movie.title
                    manageMovie.posterPath = movie.posterPath
                    manageMovie.url = movie.posterURL
                }
                print("insert feed to coredata success")
                try context.save()
                completion(.success(()))
            } catch (let error) {
                print("insert feed to coredata failed")
                completion(.failure(error))
            }
            
        }
    }
    
    func retrieve(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let context = self.context
        context.perform {
            do {
                let request = NSFetchRequest<ManageMovie>(entityName: ManageMovie.entity().name!)
                let items = try context.fetch(request)
                completion(.success(items.map { Movie(id: Int($0.id), title: $0.title, posterPath: $0.posterPath) }))
                
                try context.save()
            } catch (let error) {
                print("retrieve feed failed")
                completion(.failure(error))
            }
        }
    }
    
}
