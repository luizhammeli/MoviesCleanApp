//
//  TestFactories.swift
//  DataTests
//
//  Created by Luiz Diniz Hammerli on 24/02/22.
//

import Foundation
import Domain
import Data

func anyURL(stringValue: String = "https://test.com") -> URL {
    return URL(string: stringValue)!
}

func anyData(stringValue: String = "https://test.com") -> Data {
    return Data("invalid json".description.utf8)
}

func anyMovie(id: Int, title: String, poster_path: String) -> Movie {
    return Movie(id: id, title: title, posterPath: poster_path)
}

func anyMovieResponse(movie: [Movie]) -> MovieResponse {
    return MovieResponse(results: movie)
}
