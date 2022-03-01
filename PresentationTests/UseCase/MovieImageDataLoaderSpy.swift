//
//  MovieImageDataLoaderSpy.swift
//  PresentationTests
//
//  Created by Luiz Diniz Hammerli on 01/03/22.
//

import Foundation
import Domain

final class MovieImageDataLoaderSpy: MovieImageDataLoader {
    var completions: [(MovieImageDataLoader.Result) -> Void] = []
    func loadFeedImageData(from url: URL, completion: @escaping (MovieImageDataLoader.Result) -> Void) {
        completions.append(completion)
    }

    func complete(with result: MovieImageDataLoader.Result, at index: Int = 0) {
        completions[index](result)
    }
}
