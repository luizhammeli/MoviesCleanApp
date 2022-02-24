//
//  MovieResponse+Encoder.swift
//  DataTests
//
//  Created by Luiz Diniz Hammerli on 24/02/22.
//

import Foundation
import Data

extension MovieResponse {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
