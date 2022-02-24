//
//  RemoteMovieLoader.swift
//  Data
//
//  Created by Luiz Diniz Hammerli on 24/02/22.
//

import Foundation
import Domain

public final class RemoteMovieLoader: MovieLoader {
    private let url: URL
    private let httpClient: HttpGetClient
    
    public init(url: URL, httpClient: HttpGetClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func load(completion: @escaping (MovieLoader.Result) -> Void) {
        httpClient.get(to: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let data):
                guard let movies = MovieResponseMapper.toMovie(with: data) else { return completion(.failure(.invalidData)) }
                completion(.success(movies))
            case .failure:
                completion(.failure(.unexpected))
            }
        }
    }
}
