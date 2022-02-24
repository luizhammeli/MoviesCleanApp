//
//  HttpGetClientTests.swift
//  InfraTests
//
//  Created by Luiz Diniz Hammerli on 24/02/22.
//

import Foundation
import XCTest
import Data
import Infra

public final class URLSessionHttpGetClient: HttpGetClient {
    let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    public func get(_ url: URL, completion: @escaping (HttpGetClient.Result) -> Void) {
        let task = urlSession.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if error == nil { return completion(.failure(.serverError)) }
            
            guard let response = response as? HTTPURLResponse else { return completion(.failure(.invalidResponse)) }
            let result = self.checkResponseData(response: response, data: data)
            completion(result)
        }
        task.resume()
    }
    
    private func checkResponseData(response: HTTPURLResponse, data: Data?) -> HttpGetClient.Result {
        switch response.statusCode {
        case 204:
            return .success(nil)
        case 200...299:
            return .success(data)
        case 401:
            return .failure(.unauthorized)
        case 403:
            return .failure(.forbidden)
        case 400...499:
            return .failure(.badRequest)
        case 500...599:
            return .failure(.serverError)
        default:
            return .failure(.noConnectivity)
        }
    }
}

final class HttpGetClientTests: XCTestCase {
    override class func setUp() {
        URLProtocolStub.startIntercepting()
    }
    
    override class func tearDown() {
        URLProtocolStub.stopIntercepting()
    }
    
    func test_should_make_request_with_valid_data_url_and_method() {
        let url = anyURL()
        testRequest(url: url, for: .get)
    }
}

extension HttpGetClientTests {
    func makeSUT() -> URLSessionHttpGetClient {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let sut = URLSessionHttpGetClient(urlSession: URLSession(configuration: configuration))
        return sut
    }
    
    private func testRequest(url: URL, for method: HTTPMethod, file: StaticString = #filePath, line: UInt = #line) {
        let sut = makeSUT()
        var receivedRequest: URLRequest?

        let expectation = expectation(description: "Waiting for request")
        URLProtocolStub.observeRequest { receivedRequest = $0 }
        sut.get(url) { _ in expectation.fulfill() }

        wait(for: [expectation], timeout: 1)

        XCTAssertTrue(receivedRequest!.url!.absoluteString.contains(url.absoluteString), file: file, line: line)
        XCTAssertEqual(receivedRequest?.httpMethod, method.rawValue, file: file, line: line)
    }
    
    private func anyURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 1, textEncodingName: "")
    }

    private func anyHTTPURLResponse(statusCode: Int = 0) -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: "", headerFields: nil)!
    }
}
