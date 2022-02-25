//
//  MovieViewPresenterTests.swift
//  PresentationTests
//
//  Created by Luiz Diniz Hammerli on 25/02/22.
//

import XCTest
import Data
import Domain
import Presentation

final class MovieViewPresenterTests: XCTestCase {
    func test_init_shouldNotLoadMovies() {
        let (_, loader) = makeSUT()
        XCTAssertTrue(loader.completions.isEmpty)
    }
    
    func test_didStartLoadingMovies_shouldSendIsLoadingViewMessage() {
        let viewSpy = MovieViewSpy()
        let (sut, _) = makeSUT(loadingView: viewSpy)
        
        sut.loadMovies()
        XCTAssertEqual(viewSpy.messages, [.display(isLoading: true)])
    }
    
    func test_didFinishLoadingMoviesWithError_shouldSendIsLoadingViewMessage() {
        let viewSpy = MovieViewSpy()
        let (sut, loader) = makeSUT(loadingView: viewSpy, alertView: viewSpy)
        
        sut.loadMovies()
        loader.complete(with: .failure(.unexpected), at: 0)
        XCTAssertEqual(viewSpy.messages, [.display(isLoading: true),
                                          .display(isLoading: false),
                                          .display(alert: MovieAlertViewModel(title: "Erro", message: "Ocorreu um erro inesperado."))])
    }
    
    func test_didFinishLoadingMoviesWithSuccess_shouldSendIsLoadingViewMessage() {
        let viewSpy = MovieViewSpy()
        let baseURL = anyURL()
        let (sut, loader) = makeSUT(baseURL: baseURL.description, loadingView: viewSpy, movieView: viewSpy)
        let data = toMovieModels(baseURL: baseURL.description, id: 10, title: "Test Title", posterPath: "\(UUID().description)")
        
        sut.loadMovies()
        loader.complete(with: .success([data.model]), at: 0)
        XCTAssertEqual(viewSpy.messages, [.display(isLoading: true), .display(isLoading: false), .display(movies: [data.movieViewModel])])
    }
}

// MARK: Helpers
private extension MovieViewPresenterTests {
    func makeSUT(baseURL: String = "test",
                 loadingView: MovieLoadingView = MovieViewSpy(),
                 alertView: MovieAlertView = MovieViewSpy(),
                 movieView: MovieView = MovieViewSpy()) -> (MovieViewPresenter, RemoteMovieLoaderSpy) {
        let loaderSpy = RemoteMovieLoaderSpy()
        let sut = MovieViewPresenter(imageBaseURL: baseURL, loader: loaderSpy, loadingView: loadingView, movieView: movieView, alertView: alertView)
        checkMemoryLeak(for: sut)
        return (sut, loaderSpy)
    }
    
    func toMovieModels(baseURL: String = "test", id: Int, title: String, posterPath: String) -> (model: Movie, movieViewModel: MovieViewModel) {
        let movie = anyMovie(id: id, title: title, poster_path: posterPath)
        let url = URL(string: "\(baseURL + movie.posterPath)")!
        let movieViewModel = MovieViewModel(title: movie.title, imageURL: url)
        return (movie, movieViewModel)
    }
}

final class RemoteMovieLoaderSpy: MovieLoader {
    var completions: [(MovieLoader.Result) -> Void] = []
    
    func load(completion: @escaping (MovieLoader.Result) -> Void) {
        completions.append(completion)
    }
    
    func complete(with result: MovieLoader.Result, at index: Int) {
        completions[index](result)
    }
}
