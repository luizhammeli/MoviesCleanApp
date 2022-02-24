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
        httpClient.get(to: url) { result in
            
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
    
//    func test_load_deliversErrorOnClientError() {
//        let (sut, clientSpy) = makeSut()
//        expect(sut: sut, toCompleteWith: failure(.connectivity)) {
//            clientSpy.complete(with: NSError(domain: "", code: 0, userInfo: nil))
//        }
//    }
}

// MARK: - Helpers
private extension RemoteMovieLoaderTests {
    func anyURL(stringValue: String = "https://test.com") -> URL {
        return URL(string: stringValue)!
    }
    
    func makeSut(url: URL = URL(string: "https://test.com")!) -> (RemoteMovieLoader, HttpGetClientSpy) {
        let clientSPY = HttpGetClientSpy()
        let sut = RemoteMovieLoader(url: anyURL(), httpClient: clientSPY)
        return (sut, clientSPY)
    }
}

final class HttpGetClientSpy: HttpGetClient {
    private var messages: [(url: URL, completion: (Result<Data?, HttpError>) -> Void)] = []
    
    var requestedURLS: [URL] {
        return messages.map { $0.url }
    }
    
    var messagesCount: Int {
        messages.count
    }
    
    func get(to url: URL, completion: @escaping (Result<Data?, HttpError>) -> Void) {
        messages.append((url, completion))
    }
}
