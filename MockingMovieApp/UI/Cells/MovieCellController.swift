//
//  MovieCellController.swift
//  MockingMovieApp
//
//  Created by Tan Tan on 8/18/22.
//

import UIKit

class MovieCellController: Hashable {
    let imageDataLoader: ImageDataLoader?
    let item: Movie
    var task: ImageDataLoaderTask?
    
    init(loader: ImageDataLoader?, item: Movie) {
        self.imageDataLoader = loader
        self.item = item
    }
    
    func view(in tableView: UITableView) -> MovieCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as? MovieCell else { return MovieCell() }
        
        cell.titleLabel.text = item.title
        cell.backgroundImageView.image = nil
        cell.backgroundImageView.isShimmering = true
        if let url = item.posterURL {
            self.task = self.imageDataLoader?.loadImageData(url: url, completion: { result in
                if let data = try? result.get() {
                    DispatchQueue.main.async {
                        cell.backgroundImageView.isShimmering = false
                        cell.backgroundImageView.setImageAnimated(UIImage(data: data))
                    }
                }
            })
        }
        return cell
    }
    
    func preload() {
        guard let url = item.posterURL else { return }
        self.task = self.imageDataLoader?.loadImageData(url: url, completion: { _ in })
    }
    
    func cancelLoad() {
        task?.cancel()
        task = nil
    }
    
    static func == (lhs: MovieCellController, rhs: MovieCellController) -> Bool {
        return lhs.item.id == rhs.item.id
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(item.id)
    }
}
