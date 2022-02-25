//
//  MovieViewPresenterTests.swift
//  PresentationTests
//
//  Created by Luiz Diniz Hammerli on 25/02/22.
//

import XCTest
import Data
import Domain
//import Presentation

final class MovieViewPresenter {
    private let loader: MovieLoader
    
    public init(loader: MovieLoader) {
        self.loader = loader
    }
}

final class MovieViewPresenterTests: XCTestCase {
    func test_() throws {
    }
}

// MARK: Helpers
private extension MovieViewPresenterTests {
    func makeSUT() -> (MovieViewPresenter, RemoteMovieLoaderSpy) {
        let loaderSpy = RemoteMovieLoaderSpy()
        let sut = MovieViewPresenter(loader: loaderSpy)
        return (sut, loaderSpy)
    }
}

final class RemoteMovieLoaderSpy: MovieLoader {
    func load(completion: @escaping (MovieLoader.Result) -> Void) {
        
    }
}
