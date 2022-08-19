//
//  RefreshViewController.swift
//  MockingMovieApp
//
//  Created by Tan Tan on 8/18/22.
//

import UIKit

class RefreshViewController {
    lazy var view: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private var loader: FeedLoader
    var onFeedLoaded: ([Movie]) -> Void = { _ in }
    
    init(loader: FeedLoader) {
        self.loader = loader
    }
    
    @objc
    func refresh() {
        self.view.beginRefreshing()
        loader.fetchMovies(page: 1, completion: { [weak self] result in
            DispatchQueue.main.async {
                self?.view.endRefreshing()
                if let movies = try? result.get() {
                    self?.onFeedLoaded(movies)
                }
            }
        })
    }
}
