//
//  RemoteMovieImageDataLoaderTests.swift
//  DataTests
//
//  Created by Luiz Hammerli on 26/02/22.
//

import XCTest
import Domain
import Data

final class RemoteMovieImageDataLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURl() {
        let (_, clientSpy) = makeSut()
        
        XCTAssertEqual(clientSpy.messagesCount, 0)
    }
    
    func test_load_requestsDataFromURl() {
        let url = anyURL()
        let (sut, clientSpy) = makeSut()
                
        sut.loadFeedImageData(from: url, completion: { _ in })
        
        XCTAssertEqual(clientSpy.requestedURLS, [url])
    }
    
    func test_loadTwice_requestsDataFromURlTwice() {
        let url = anyURL()
        let (sut, clientSpy) = makeSut()
        
        sut.loadFeedImageData(from: url, completion: { _ in })
        sut.loadFeedImageData(from: url, completion: { _ in })
        
        XCTAssertEqual(clientSpy.requestedURLS, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, clientSpy) = makeSut()
        expect(sut: sut, toCompleteWith: .failure(.unexpected)) {
            clientSpy.complete(with: .failure(.unauthorized))
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
        expect(sut: sut, toCompleteWith: .success(anyData())) {
            clientSpy.complete(with: .success(anyData()))
        }
    }
    
    func test_load_doesNotDeliversResultAfterSutHasBeenDealocatted() {
        let clientSPY = HttpGetClientSpy()
        var sut: RemoteMovieImageDataLoader? = RemoteMovieImageDataLoader(client: clientSPY)
        var capturedErrors: [MovieImageDataLoader.Result] = []
        
                
        sut?.loadFeedImageData(from: anyURL(), completion: { capturedErrors.append($0) })
        sut = nil
        clientSPY.complete(with: .failure(.noConnectivity))
        XCTAssertTrue(capturedErrors.isEmpty)
    }
}

// MARK: - Helpers
private extension RemoteMovieImageDataLoaderTests {
    func makeSut(file: StaticString = #filePath,
                 line: UInt = #line) -> (RemoteMovieImageDataLoader, HttpGetClientSpy) {
        let clientSPY = HttpGetClientSpy()
        let sut = RemoteMovieImageDataLoader(client: clientSPY)
        checkMemoryLeak(for: clientSPY)
        checkMemoryLeak(for: sut)
        return (sut, clientSPY)
    }
    
    func expect(sut: RemoteMovieImageDataLoader,
                toCompleteWith expectedResult: MovieImageDataLoader.Result,
                when action: () -> Void,
                file: StaticString = #filePath,
                line: UInt = #line) {
        let expectation = expectation(description: "Waiting for request")
        sut.loadFeedImageData(from: anyURL()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case (.success(let receivedItems), .success(let expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case (.failure(let receivedError), .failure(let expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Assert error expect \(expectedResult) receive \(receivedResult) instead", file: file, line: line)
            }
            expectation.fulfill()
        }
        action()
        wait(for: [expectation], timeout: 1)
    }
}
