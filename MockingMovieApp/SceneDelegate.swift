//
//  SceneDelegate.swift
//  MockingMovieApp
//
//  Created by Tan Tan on 8/10/22.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // Add feature 1

    var window: UIWindow?
    
    var coreDataService: CoreDataStore {
        try! CoreDataStore(storeURL: NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("moviedb-store-sqlite"))
    }


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        print(NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("moviedb-store-sqlite").absoluteString)
        let localFeedStore = LocalFeedService(store: self.coreDataService)
        let localDataStore = LocalImageDataService(store: self.coreDataService)
        

        let apiService = FeedLoaderWithFallback(primary: FeedLoaderCacheDecorator(decoratee: makeRemoteLoader(), cache: localFeedStore),
                                                fallback: localFeedStore)
        
        let imageDataLoader = ImageDataLoaderWithFallback(primary: localDataStore,
                                                          fallback: ImageDataLoaderCacheDecorator(
                                                            decoratee: makeRemoteImageDataLoader(),
                                                            cache: localDataStore))
        
        let refreshViewController = RefreshViewController(loader: apiService)
        let loadMoreController = LoadMoreCellController(loader: makeRemoteLoader())
        
        let vc = HomeViewController(refreshViewController: refreshViewController,
                                    loadMoreController: loadMoreController)
        
        refreshViewController.onFeedLoaded = { movies in
            let controllers = movies.map { MovieCellController(loader: imageDataLoader, item: $0)}
            vc.set(controllers)
        }
        
        loadMoreController.onPaging = { movies in
            let controllers = movies.map { MovieCellController(loader: imageDataLoader, item: $0)}
            vc.append(controllers)
        }
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
        
    }
    
    func makeRemoteLoader() -> FeedLoader {
        let apiService = APIService(client: URLSessionHTTPClient())
        return apiService
    }
    
    func makeRemoteImageDataLoader() -> ImageDataLoader {
        let apiService = APIService(client: URLSessionHTTPClient())
        return apiService
    }
    
}

class FeedLoaderCacheDecorator: FeedLoader {
    private let decoratee: FeedLoader
    private let cache: FeedCache
    
    init(decoratee: FeedLoader, cache: FeedCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func fetchMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        decoratee.fetchMovies(page: page) { [weak self] result in
            if let movies = try? result.get() {
                self?.cache.save(movies, completion: { _ in })
            }
            completion(result)
        }
    }
}

class ImageDataLoaderCacheDecorator: ImageDataLoader {
    
    private let decoratee: ImageDataLoader
    private let cache: FeedImageDataCache
    
    init(decoratee: ImageDataLoader, cache: FeedImageDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func loadImageData(url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> ImageDataLoaderTask {
        decoratee.loadImageData(url: url) { [weak self] result in
            completion(result.map { data in
                self?.cache.save(data, for: url, completion: { _ in })
                return data
            })
        }
    }
}

class FeedLoaderWithFallback: FeedLoader {
    private let primary: FeedLoader
    private let fallback: FeedLoader
    
    init(primary: FeedLoader, fallback: FeedLoader) {
        self.primary = primary
        self.fallback = fallback
    }
    
    func fetchMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        self.primary.fetchMovies(page: page) { result in
            switch result {
            case .success(let movies):
                completion(.success(movies))
            case .failure:
                self.fallback.fetchMovies(page: page, completion: completion)
            }
        }
    }
}

class ImageDataLoaderWithFallback: ImageDataLoader {
    
    let primary: ImageDataLoader
    let fallback: ImageDataLoader
    
    init(primary: ImageDataLoader, fallback: ImageDataLoader) {
        self.primary = primary
        self.fallback = fallback
    }

    func loadImageData(url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> ImageDataLoaderTask {
        self.primary.loadImageData(url: url) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure:
                _ = self.fallback.loadImageData(url: url, completion: completion)
            }
        }
    }
}
