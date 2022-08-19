//
//  LoadMoreCellController.swift
//  MockingMovieApp
//
//  Created by Tan Tan on 8/18/22.
//

import UIKit

class LoadMoreCellController: Hashable {
    let id: AnyHashable = UUID()
    private let loader: FeedLoader?
    private var page: Int = 1
    private var isLoadMore: Bool = false
    var onPaging: (([Movie]) -> Void) = { _ in }
    
    internal init(loader: FeedLoader?) {
        self.loader = loader
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreCell") as? LoadMoreCell else { return UITableViewCell() }
        return cell
    }
    
    func loadMore() {
        guard !isLoadMore else { return }
        self.page += 1
        self.loader?.fetchMovies(page: self.page, completion: { [weak self] result in
            DispatchQueue.main.async {
                guard let movies = try? result.get() else { return }
                self?.onPaging(movies)
            }
        })
    }
    
    static func == (lhs: LoadMoreCellController, rhs: LoadMoreCellController) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}
