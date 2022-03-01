//
//  MovieImageView.swift
//  Presentation
//
//  Created by Luiz Diniz Hammerli on 01/03/22.
//

import Foundation

public protocol MovieImageView {
    associatedtype Image: Equatable
    func display(image: Image?)
}
