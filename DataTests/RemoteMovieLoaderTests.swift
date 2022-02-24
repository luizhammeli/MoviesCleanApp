//
//  RemoteMovieLoaderTests.swift
//  DataTests
//
//  Created by Luiz Diniz Hammerli on 24/02/22.
//

import Foundation
import XCTest
import Domain
import Data

final class RemoteMovieLoader: MovieLoader {
    let url: URL
    let httpClient: HttpGetClient
    
    public init(url: URL, httpClient: HttpGetClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func load(completion: @escaping (MovieLoader.Result) -> Void) {
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

final class RemoteMovieLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURl() {
        let (_, clientSpy) = makeSut()
        
        XCTAssertEqual(clientSpy.messagesCount, 0)
    }
    
    func test_load_requestsDataFromURl() {
        let url = anyURL()
        let (sut, clientSpy) = makeSut(url: url)
        
        sut.load(completion: { _ in })
        
        XCTAssertEqual(clientSpy.requestedURLS, [url])
    }
    
    func test_loadTwice_requestsDataFromURlTwice() {
        let url = anyURL()
        let (sut, clientSpy) = makeSut(url: url)
        
        sut.load(completion: { _ in })
        sut.load(completion: { _ in })
        
        XCTAssertEqual(clientSpy.requestedURLS, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, clientSpy) = makeSut()
        expect(sut: sut, toCompleteWith: .failure(.unexpected)) {
            clientSpy.complete(with: .failure(.unauthorized))
        }
    }
    
    func test_load_deliversErrorOn200HttpResponseWithInvalidData() {
        let (sut, clientSpy) = makeSut()
        expect(sut: sut, toCompleteWith: .failure(.invalidData)) {
            clientSpy.complete(with: .success(anyData()))
        }
    }
    
    func test_load_deliversErrorOn200HttpResponseWithEmptyData() {
        let (sut, clientSpy) = makeSut()
        expect(sut: sut, toCompleteWith: .failure(.invalidData)) {
            clientSpy.complete(with: .success(Data()))
        }
    }
    
    func test_load_deliversSuccessOn200HttpResponseWithCorrectData() {
        let (sut, clientSpy) = makeSut()
        let movies = [anyMovie(id: 10, title: "Test Movie", poster_path: "/path")]
        let response = anyMovieResponse(movie: movies)
        expect(sut: sut, toCompleteWith: .success(movies)) {
            clientSpy.complete(with: .success(response.toData()))
        }
    }
    
    func test_load_deliversSuccessWithNoItemsOn200HttpResponseWithValidData() {
        let (sut, clientSpy) = makeSut()
        let response = anyMovieResponse(movie: [])
        expect(sut: sut, toCompleteWith: .success([])) {
            clientSpy.complete(with: .success(response.toData()))
        }
    }
    
    func test_load_doesNotDeliversResultAfterSutHasBeenDealocatted() {
        let clientSPY = HttpGetClientSpy()
        var sut: RemoteMovieLoader? = RemoteMovieLoader(url: anyURL(), httpClient: clientSPY)
        var capturedErrors: [MovieLoader.Result] = []
        
        sut?.load(completion: { capturedErrors.append($0) })
        sut = nil
        clientSPY.complete(with: .failure(.noConnectivity))
        XCTAssertTrue(capturedErrors.isEmpty)
    }
}

// MARK: - Helpers
private extension RemoteMovieLoaderTests {
    func makeSut(url: URL = URL(string: "https://test.com")!) -> (RemoteMovieLoader, HttpGetClientSpy) {
        let clientSPY = HttpGetClientSpy()
        let sut = RemoteMovieLoader(url: anyURL(), httpClient: clientSPY)
        return (sut, clientSPY)
    }
    
    private func expect(sut: RemoteMovieLoader,
                        toCompleteWith expectedResult: MovieLoader.Result,
                        when action: () -> Void,
                        file: StaticString = #filePath,
                        line: UInt = #line) {
        let expectation = expectation(description: "Waiting for request")
        sut.load(completion: { receivedResult in
            switch (receivedResult, expectedResult) {
            case (.success(let receivedItems), .success(let expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case (.failure(let receivedError), .failure(let expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Assert error expect \(expectedResult) receive \(receivedResult) instead", file: file, line: line)
            }
            expectation.fulfill()
        })
        action()
        wait(for: [expectation], timeout: 1)
    }
}
