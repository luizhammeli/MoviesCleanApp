//
//  MovieResponse.swift
//  Data
//
//  Created by Luiz Diniz Hammerli on 24/02/22.
//

import Foundation
import Domain

struct MovieResponse: Codable, Equatable {
    let results: [Movie]
}
