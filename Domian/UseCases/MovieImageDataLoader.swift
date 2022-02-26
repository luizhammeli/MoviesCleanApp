//
//  MovieImageDataLoader.swift
//  Domain
//
//  Created by Luiz Hammerli on 26/02/22.
//

import Foundation

public protocol MovieImageDataLoaderTask {
    func cancel()
}

public protocol MovieImageDataLoader {
    typealias Result = Swift.Result<Data, DomainError>
    func loadFeedImageData(from url: URL, completion: @escaping (Result) -> Void)
}
