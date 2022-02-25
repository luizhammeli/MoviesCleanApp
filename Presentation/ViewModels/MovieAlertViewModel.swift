//
//  MovieAlertViewModel.swift
//  Presentation
//
//  Created by Luiz Diniz Hammerli on 25/02/22.
//

import Foundation

public struct MovieAlertViewModel: Equatable, Hashable {
    public let title: String
    public let message: String
    
    public init(title: String, message: String) {
        self.title = title
        self.message = message
    }
}
