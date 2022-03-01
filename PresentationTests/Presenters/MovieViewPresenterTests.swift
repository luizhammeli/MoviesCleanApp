//
//  MovieViewPresenterTests.swift
//  PresentationTests
//
//  Created by Luiz Diniz Hammerli on 25/02/22.
//

import XCTest
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
                                          .display(alert: MovieAlertViewModel(title: getErrorMessages().0,
                                                                              message: getErrorMessages().1))])
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

    func test_title_shouldReturnCorrectTitle() {
        XCTAssertEqual(MovieViewPresenter.title, getLocalizedString())
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
        checkMemoryLeak(for: loaderSpy)
        checkMemoryLeak(for: sut)
        return (sut, loaderSpy)
    }

    func toMovieModels(baseURL: String = "test", id: Int, title: String, posterPath: String) -> (model: Movie, movieViewModel: MovieViewModel) {
        let movie = Movie(id: id, title: title, posterPath: posterPath)
        let url = URL(string: "\(baseURL + movie.posterPath)")!
        let movieViewModel = MovieViewModel(title: movie.title, imageURL: url)
        return (movie, movieViewModel)
    }

    func getLocalizedString(for key: String = "MOVIE_VIEW_TITLE") -> String {
        return NSLocalizedString(key,
                                 tableName: "Movie",
                                 bundle: Bundle(for: MovieViewPresenter.self), comment: "")
    }

    func getErrorMessages() -> (String, String) {
        return (getLocalizedString(for: MovieViewPresenter.errorTitle),
                getLocalizedString(for: MovieViewPresenter.errorMessage))
    }

    func anyURL(stringValue: String = "https://test.com") -> URL {
        return URL(string: stringValue)!
    }
}
