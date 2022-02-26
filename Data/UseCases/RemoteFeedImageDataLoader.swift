//
//  RemoteFeedImageDataLoader.swift
//  Data
//
//  Created by Luiz Hammerli on 26/02/22.
//

import Foundation
import Domain

public final class DefaultFeedImageDataLoaderTask: FeedImageDataLoaderTask {
    let task: HttpClientTask
    
    init(task: HttpClientTask) {
        self.task = task
    }
    
    public func cancel() {
        task.cancel()
    }
}

public final class RemoteFeedImageDataLoader: FeedImageDataLoader {
    let client: HttpGetClient
    
    public init(client: HttpGetClient) {
        self.client = client
    }
    
    //@discardableResult
    public func loadFeedImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) {
        client.get(url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .failure:
                completion(.failure(.unexpected))
            case .success((let data)):
                guard let data = data, data.isEmpty else {
                    return completion(.failure(.invalidData))
                }
                completion(.success(data))
            }
        }
        //return DefaultFeedImageDataLoaderTask(task: task)
    }
}
