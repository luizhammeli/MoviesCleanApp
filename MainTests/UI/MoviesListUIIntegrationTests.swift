//
//  UIIntegrationTests.swift
//  MainTests
//
//  Created by Luiz Diniz Hammerli on 27/02/22.
//

import XCTest
import Domain
import UI
import Presentation
@testable import Main

final class MoviesListUIIntegrationTests: XCTestCase {
    func test_init_doesNotStartLoadingMoviesFlow(){
        let (_, loaderSpy) = makeSUT()
        XCTAssertTrue(loaderSpy.completions.isEmpty)
    }
    
    func test_didLoad_shouldShowCorrectTitle(){
        let (sut, _) = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.title, localized(key: "MOVIE_VIEW_TITLE"))
    }
    
    func test_didLoad_shouldStartLoadingMoviesFlow(){
        let (sut, loaderSpy) = makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertEqual(loaderSpy.completions.count, 1)
    }
    
    func test_loadingIndicator_isVisibleWhileLoadingMoviesWithError() {
        simulateAndAssertTheLoadingIndicatorWhenLoaderCompletes(with: .failure(.unexpected))
    }
    
    func test_loadingIndicator_isVisibleWhileLoadingMoviesWithSuccess() {
        simulateAndAssertTheLoadingIndicatorWhenLoaderCompletes(with: .success([]))
    }
}

// MARK: - Helpers
private extension MoviesListUIIntegrationTests {
    func makeSUT() -> (MoviesCollectionViewController, RemoteMovieLoaderSpy) {
        let loader = RemoteMovieLoaderSpy()
        let sut = makeMovieController(movieLoader: loader)
        checkMemoryLeak(for: loader)
        checkMemoryLeak(for: sut)
        return (sut, loader)
    }
    
    private func localized(key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let bundle = Bundle(for: MovieViewPresenter.self)
        let localizedTitle = bundle.localizedString(forKey: key, value: nil, table: "Movie")
        
        if localizedTitle == key {
            XCTFail("Missing localized string for key: \(key)", file: file, line: line)
        }
        
        return localizedTitle
    }
    
    private func simulateAndAssertTheLoadingIndicatorWhenLoaderCompletes(with result: MovieLoader.Result, file: StaticString = #filePath, line: UInt = #line) {
        let (sut, loaderSpy) = makeSUT()
        sut.loadViewIfNeeded()
                
        XCTAssertTrue(sut.isLoadingIndicatorVisible(), file: file, line: line)
        
        loaderSpy.complete(with: .success([]), at: 0)
        
        XCTAssertFalse(sut.isLoadingIndicatorVisible(), file: file, line: line)
    }
}

// MARK: - MoviesCollectionViewController
private extension MoviesCollectionViewController {
    func isLoadingIndicatorVisible() -> Bool {
        let loadingIndicator = view.subviews.last as! UIActivityIndicatorView
        return loadingIndicator.isAnimating
    }
}
