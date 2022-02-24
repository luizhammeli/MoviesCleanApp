//
//  MovieResponse.swift
//  Data
//
//  Created by Luiz Diniz Hammerli on 24/02/22.
//

import Foundation
import Domain

public struct MovieResponse: Codable, Equatable {
    public let results: [Movie]
        
    public init(results: [Movie]) {
        self.results = results
    }
}

public final class MovieResponseMapper {
    public static func toMovie(with data: Data?) -> [Movie]? {
        guard let data = data else { return nil }
        guard let movieResponse = try? JSONDecoder().decode(MovieResponse.self, from: data) else { return nil }
        return movieResponse.results
    }
}
