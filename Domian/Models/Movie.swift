//
//  Movie.swift
//  Domain
//
//  Created by Luiz Diniz Hammerli on 24/02/22.
//

import Foundation

public struct Movie: Codable, Equatable {
    public let id: Int
    public let title: String
    public let posterPath: String

    public init(id: Int, title: String, posterPath: String) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
    }

    public enum CodingKeys: String, CodingKey {
        case id, title
        case posterPath = "poster_path"
    }
}
