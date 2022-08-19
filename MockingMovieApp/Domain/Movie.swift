//
//  Movie.swift
//  MockingMovieApp
//
//  Created by Tan Tan on 8/11/22.
//

import Foundation

struct Movie: Decodable, Hashable {
    let id: Int
    let title: String
    let posterPath: String
    
    init(id: Int, title: String, posterPath: String) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
    }
    
    var posterURL: URL? {
        URL(string: "\(ROOT_IMAGE)w500/\(posterPath)")
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "original_title"
        case posterPath = "poster_path"
    }
}
