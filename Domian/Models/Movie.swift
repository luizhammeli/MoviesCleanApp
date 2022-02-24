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
    let poster_path: String?
    
    public init(id: Int, title: String, poster_path: String?) {
        self.id = id
        self.title = title
        self.poster_path = poster_path        
    }
}
