//
//  Constant.swift
//  MockingMovieApp
//
//  Created by Tan Tan on 8/17/22.
//

import Foundation

let API_Key = "d30196018ffea96c0d32f84262af7fe6"
let ROOT = "https://api.themoviedb.org"
let ROOT_IMAGE = "http://image.tmdb.org/t/p/"

enum Endpoints {
    case movies(page: Int)
    
    var url: String {
        switch self {
        case .movies(let page):
            return "\(ROOT)/3/movie/popular/?api_key=\(API_Key)&page=\(page)"
        }
    }
}
