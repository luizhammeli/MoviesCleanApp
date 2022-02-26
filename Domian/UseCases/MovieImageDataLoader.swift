//
//  MovieImageDataLoader.swift
//  Domain
//
//  Created by Luiz Hammerli on 26/02/22.
//

import Foundation

public protocol FeedImageDataLoaderTask {
    func cancel()
}

public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, DomainError>
    func loadFeedImageData(from url: URL, completion: @escaping (Result) -> Void)
}
