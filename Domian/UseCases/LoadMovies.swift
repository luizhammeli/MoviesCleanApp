//
//  LoadMovies.swift
//  Domain
//
//  Created by Luiz Diniz Hammerli on 24/02/22.
//

import Foundation

public protocol MovieLoader {
    typealias Result = Swift.Result<[Movie], DomainError>
    func load(completion: @escaping (Result) -> Void)
}
