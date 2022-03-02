//
//  RemoteFeedImageDataLoader.swift
//  Data
//
//  Created by Luiz Hammerli on 26/02/22.
//

import Foundation
import Domain

//TODO: - DefaultMovieImageDataLoaderTask
//public final class DefaultMovieImageDataLoaderTask: MovieImageDataLoaderTask {
//    let task: HttpClientTask
//    
//    init(task: HttpClientTask) {
//        self.task = task
//    }
//    
//    public func cancel() {
//        task.cancel()
//    }
//}

public final class RemoteMovieImageDataLoader: MovieImageDataLoader {
    let client: HttpGetClient
    
    public init(client: HttpGetClient) {
        self.client = client
    }
    
    public func loadFeedImageData(from url: URL, completion: @escaping (MovieImageDataLoader.Result) -> Void) {
        client.get(url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .failure:
                completion(.failure(.unexpected))
            case .success((let data)):
                guard let data = data, !data.isEmpty else {
                    return completion(.failure(.invalidData))
                }
                completion(.success(data))
            }
        }
    }
}
