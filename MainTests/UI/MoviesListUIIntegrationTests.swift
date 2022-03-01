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
    
    func test_imageLoadingIndicator_isVisibleWhileLoadingMoviesWithSuccess() {
        simulateAndAssertTheImageLoadingIndicatorWhenLoaderCompletes(with: .success(Data()))
    }
    
    func test_imageLoadingIndicator_isVisibleWhileLoadingMoviesWithError() {
        simulateAndAssertTheImageLoadingIndicatorWhenLoaderCompletes(with: .failure(.unexpected))
    }
    
    func test_loadCompletion_rendersSuccessfullyLoadedFeed() {
        let imageLoaderSpy = MovieImageDataLoaderSpy()
        let (sut, loaderSpy) = makeSUT(imageLoader: imageLoaderSpy)
        XCTAssertEqual(sut.numberOfRenderedMovieViews, 0)
        
        let movie0 = anyMovie(id: 10, title: "Test Movie", poster_path: UUID().description)
        let movie1 = anyMovie(id: 11, title: "Test Movie 2", poster_path: UUID().description)
        
        let image0 = UIImage.make(withColor: .blue).pngData()!
        let image1 = UIImage.make(withColor: .red).pngData()!
        
        sut.loadViewIfNeeded()
        loaderSpy.complete(with: .success([movie0, movie1]), at: 0)
        
        XCTAssertEqual(sut.numberOfRenderedMovieViews, 2)
        
        let movieView0 = sut.movieViewAt(index: 0)
        let movieView1 = sut.movieViewAt(index: 1)
        
        imageLoaderSpy.complete(with: .success(image0), at: 0)
        imageLoaderSpy.complete(with: .success(image1), at: 1)
        
        XCTAssertEqual(movieView0.title, movie0.title)
        XCTAssertEqual(movieView1.title, movie1.title)
        
        XCTAssertEqual(movieView0.image?.pngData(), image0)
        XCTAssertEqual(movieView1.image?.pngData(), image1)
    }
    
    func test_loadCompletion_rendersNoViewsWhenLoadingCompletesWithError() {
        let (sut, loaderSpy) = makeSUT()
        XCTAssertEqual(sut.numberOfRenderedMovieViews, 0)
        
        sut.loadViewIfNeeded()
        loaderSpy.complete(with: .failure(.unexpected), at: 0)
        
        XCTAssertEqual(sut.numberOfRenderedMovieViews, 0)
    }
}

// MARK: - Helpers
private extension MoviesListUIIntegrationTests {
    func makeSUT(imageLoader: MovieImageDataLoader = MovieImageDataLoaderSpy()) -> (MoviesCollectionViewController, RemoteMovieLoaderSpy) {
        let loader = RemoteMovieLoaderSpy()
        let sut = makeMovieController(movieLoader: loader, imageLoader: imageLoader)
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
        
        loaderSpy.complete(with: result, at: 0)
        
        XCTAssertFalse(sut.isLoadingIndicatorVisible(), file: file, line: line)
    }
    
    private func simulateAndAssertTheImageLoadingIndicatorWhenLoaderCompletes(with result: MovieImageDataLoader.Result,
                                                                              file: StaticString = #filePath,
                                                                              line: UInt = #line) {
        let imageLoaderSpy = MovieImageDataLoaderSpy()
        let (sut, loaderSpy) = makeSUT(imageLoader: imageLoaderSpy)
        sut.loadViewIfNeeded()
        
        loaderSpy.complete(with: .success([anyMovie(id: 10, title: "", poster_path: "")]), at: 0)
        let movieView = sut.movieViewAt(index: 0)
        
        XCTAssertTrue(movieView.isLoadingIndicatorVisible!, file: file, line: line)
        
        imageLoaderSpy.complete(with: result)
        
        XCTAssertFalse(movieView.isLoadingIndicatorVisible!, file: file, line: line)
    }
}

// MARK: - Helpers MoviesCollectionViewController
private extension MoviesCollectionViewController {
    func isLoadingIndicatorVisible() -> Bool {
        let loadingIndicator = view.subviews.last as! UIActivityIndicatorView
        return loadingIndicator.isAnimating
    }
    
    var numberOfRenderedMovieViews: Int {
        return collectionView.numberOfItems(inSection: 0)
    }
    
    func movieViewAt(index: Int) -> MovieCollectionViewCell {
        return collectionView(self.collectionView, cellForItemAt: IndexPath(item: index, section: 0)) as! MovieCollectionViewCell
    }
}

// MARK: - Helpers MovieCollectionViewCell
private extension MovieCollectionViewCell {
    var title: String? {
        guard let stackView = subviews.first as? UIStackView, let titleLabel = stackView.arrangedSubviews.last as? UILabel else { return nil }
        return titleLabel.text
    }
    
    var image: UIImage? {
        guard let stackView = subviews.first as? UIStackView, let imageView = stackView.arrangedSubviews.first as? UIImageView else { return nil }
        return imageView.image
    }
    
    var isLoadingIndicatorVisible: Bool? {
        guard let stackView = subviews.first as? UIStackView,
              let ac = stackView.subviews.last as? UIActivityIndicatorView else { return nil }
        return ac.isAnimating
    }
}

final class MovieImageDataLoaderSpy: MovieImageDataLoader {
    var completions: [(MovieImageDataLoader.Result) -> Void] = []
    func loadFeedImageData(from url: URL, completion: @escaping (MovieImageDataLoader.Result) -> Void) {
        completions.append(completion)
    }
    
    func complete(with result: MovieImageDataLoader.Result, at index: Int = 0) {
        completions[index](result)
    }
}
