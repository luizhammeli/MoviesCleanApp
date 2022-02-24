//
//  Movie.swift
//  Domain
//
//  Created by Luiz Diniz Hammerli on 24/02/22.
//

import Foundation

public struct Movie: Codable, Equatable {
    let id: Int
    let title: String
    let posterPath: String?
    
    public init(id: Int, title: String, posterPath: String?) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case posterPath = "poster_path"
    }
}
