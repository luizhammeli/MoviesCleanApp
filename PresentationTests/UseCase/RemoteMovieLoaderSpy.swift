//
//  RemoteMovieLoaderSpy.swift
//  PresentationTests
//
//  Created by Luiz Diniz Hammerli on 28/02/22.
//

import Domain

final class RemoteMovieLoaderSpy: MovieLoader {
    var completions: [(MovieLoader.Result) -> Void] = []

    func load(completion: @escaping (MovieLoader.Result) -> Void) {
        completions.append(completion)
    }

    func complete(with result: MovieLoader.Result, at index: Int = 0) {
        completions[index](result)
    }
}
