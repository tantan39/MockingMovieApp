//
//  ViewController.swift
//  MockingMovieApp
//
//  Created by Tan Tan on 8/10/22.
//

import UIKit

enum Section {
    case movie
    case loadMore
}

class HomeViewController: UITableViewController, UITableViewDataSourcePrefetching {
    var refreshViewController: RefreshViewController?
    var loadMoreCellController: LoadMoreCellController?
    
    lazy var dataSource = UITableViewDiffableDataSource<Section, AnyHashable>(tableView: tableView) { [weak self] tableView, indexPath, controller in
        switch controller {
        case let movieController as MovieCellController:
            return movieController.view(in: tableView)
        case let loadMoreConroller as LoadMoreCellController:
            return loadMoreConroller.view(in: tableView)
        default:
            return UITableViewCell()
        }
        
    }
    
    convenience init(refreshViewController: RefreshViewController, loadMoreController: LoadMoreCellController) {
        self.init()
        self.refreshViewController = refreshViewController
        self.loadMoreCellController = loadMoreController
    }
    
    private var page: Int = 1
    private var isLoadMore: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.refreshControl = refreshViewController?.view
        tableView.separatorStyle = .none
        tableView.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
        tableView.register(LoadMoreCell.self, forCellReuseIdentifier: "LoadMoreCell")
        tableView.prefetchDataSource = self
        
        refreshViewController?.refresh()
    }
    
    func set(_ controllers: [MovieCellController]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.movie, .loadMore])
        snapshot.appendItems(controllers, toSection: .movie)
        snapshot.appendItems([self.loadMoreCellController], toSection: .loadMore)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func append(_ controllers: [MovieCellController]) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(controllers, toSection: .movie)
        dataSource.apply(snapshot)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 250 : 40
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let controller = self.dataSource.itemIdentifier(for: indexPath) as? LoadMoreCellController else {return}
        controller.loadMore()
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let controller = self.dataSource.itemIdentifier(for: indexPath) as? MovieCellController else {return}
        controller.cancelLoad()
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let controller = self.dataSource.itemIdentifier(for: indexPath) as? MovieCellController else {return}
            controller.preload()
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let controller = self.dataSource.itemIdentifier(for: indexPath) as? MovieCellController else {return}
            controller.cancelLoad()
        }
    }
}

