//
//  MovieViewModel.swift
//  Presentation
//
//  Created by Luiz Diniz Hammerli on 25/02/22.
//

import Foundation

public struct MovieViewModel: Equatable, Hashable {
    public let title: String
    public let imageURL: URL
    
    public init(title: String, imageURL: URL) {
        self.title = title
        self.imageURL = imageURL
    }
}
