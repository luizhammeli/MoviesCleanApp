//
//  MovieImagePresenterTests.swift
//  PresentationTests
//
//  Created by Luiz Diniz Hammerli on 01/03/22.
//

import XCTest
import Presentation
import Domain

final class MovieImagePresenterTests: XCTestCase {
    func test_init_shouldNotLoadMovies() {
        let (_, loader, _) = makeSUT()
        XCTAssertTrue(loader.completions.isEmpty)
    }
    
    func test_didStartLoadingImage_shouldSendIsLoadingViewMessage() {
        let (sut, _, viewSpy) = makeSUT()
        
        sut.load(url: anyURL())
        XCTAssertEqual(viewSpy.messages, [.display(isLoading: true)])
    }
    
    func test_didFinishLoadingImageWithError_shouldSendCorrectMessages() {
        let (sut, loader, viewSpy) = makeSUT()
        
        sut.load(url: anyURL())
        loader.complete(with: .failure(.unexpected))
        
        XCTAssertEqual(viewSpy.messages, [.display(isLoading: true),
                                          .display(isLoading: false),
                                          .displayImage(nil)])
    }
    
    func test_didFinishLoadingImageWithSuccess_shouldSendCorrectMessages() {
        let (sut, loader, viewSpy) = makeSUT()
        let idValue = "invalid json".description
        
        sut.load(url: anyURL())
        loader.complete(with: .success(Data(idValue.utf8)))
        
        XCTAssertEqual(viewSpy.messages, [.display(isLoading: true),
                                          .display(isLoading: false),
                                          .displayImage(idValue)])
    }
}

private extension MovieImagePresenterTests {
    func makeSUT() -> (MovieImagePresenter<MovieImageViewSpy, ImageStub>, MovieImageDataLoaderSpy, MovieImageViewSpy) {
        let loader = MovieImageDataLoaderSpy()
        let viewSpy = MovieImageViewSpy()
        let sut = MovieImagePresenter(loader: loader, loadingView: viewSpy, view: viewSpy, imageTransformer: ImageStub.init)
        return (sut, loader, viewSpy)
    }
    
    func anyURL() -> URL {
        return URL(string: "https://test.com")!
    }
}

final class ImageStub: Equatable {
    static func == (lhs: ImageStub, rhs: ImageStub) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String
    
    init(data: Data) {
        id = String(data: data, encoding: .utf8) ?? ""
    }
}
