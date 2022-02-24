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
            if error != nil { return completion(.failure(.noConnectivity)) }
            
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

final class URLSessionHttpGetClient: XCTestCase {
    override class func setUp() {
        URLProtocolStub.startIntercepting()
    }
    
    override class func tearDown() {
        URLProtocolStub.stopIntercepting()
    }
    
    func test_fetch_shouldRequestWithCorrectURLForPostMethod() {
        testRequest(url: anyURL(), for: .get)
    }

    func test_fetch_shouldFailWhenRequestCompletesWithError() {
        expect(.failure(.noConnectivity), when: .init(data: nil, response: nil, error: anyNSError()))
    }
    
    func test_fetch_shouldFailWithAllInvalidCases() {
        expect(.failure(.invalidResponse), when: .init(data: nil, response: nil, error: nil))
        expect(.failure(.invalidResponse), when: .init(data: anyData(), response: nil, error: nil))
        expect(.failure(.invalidResponse), when: .init(data: nil, response: anyURLResponse(), error: nil))
        expect(.failure(.invalidResponse), when: .init(data: anyData(), response: anyURLResponse(), error: nil))
        expect(.failure(.invalidResponse), when: .init(data: anyData(), response: anyURLResponse(), error: nil))
        expect(.failure(.noConnectivity), when: .init(data: nil, response: anyHTTPURLResponse(), error: nil))
        expect(.failure(.noConnectivity), when: .init(data: anyData(), response: anyURLResponse(), error: anyNSError()))
    }
    
    func test_fetch_shouldFailIfRequestCompletesWithNon200Status() {
        let data = anyData()
        expect(.failure(.serverError), when: .init(data: data, response: anyHTTPURLResponse(statusCode: 500), error: nil))
        expect(.failure(.badRequest), when: .init(data: data, response: anyHTTPURLResponse(statusCode: 400), error: nil))
        expect(.failure(.unauthorized), when: .init(data: data, response: anyHTTPURLResponse(statusCode: 401), error: nil))
        expect(.failure(.forbidden), when: .init(data: data, response: anyHTTPURLResponse(statusCode: 403), error: nil))
        expect(.failure(.badRequest), when: .init(data: data, response: anyHTTPURLResponse(statusCode: 404), error: nil))
        expect(.failure(.badRequest), when: .init(data: data, response: anyHTTPURLResponse(statusCode: 499), error: nil))
        expect(.failure(.noConnectivity), when: .init(data: data, response: anyHTTPURLResponse(statusCode: 600), error: nil))
    }
    
    func test_fetch_shouldSucceedWithValidResponseAndData() {
        let data = anyData()
        expect(.success(data), when: .init(data: data, response: anyHTTPURLResponse(statusCode: 200), error: nil))
    }

    func test_fetch_shouldSucceedWithEmptyData() {
        let data = Data()
        expect(.success(data), when: .init(data: data, response: anyHTTPURLResponse(statusCode: 200), error: nil))
    }
}

extension URLSessionHttpGetClient {
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
    
    private func expect(_ expectedResult: HttpGetClient.Result, when stub: Stub, file: StaticString = #filePath, line: UInt = #line) {
        let sut = makeSUT()
        var receivedResult: HttpGetClient.Result?
        URLProtocolStub.stub(stub)
        
        let exp = expectation(description: "Waiting for Request")
        sut.get(anyURL()) { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        switch (expectedResult, receivedResult) {
        case (.success(let expectedData), .success(let receivedData)):
            XCTAssertEqual(receivedData, expectedData, file: file, line: line)
        case (.failure(let expectedError), .failure(let receivedError)):
            XCTAssertEqual(expectedError, receivedError, file: file, line: line)
        default:
            XCTFail("Expected \(expectedResult) result got \(String(describing: receivedResult)) instead")
        }
    }
    
    private func anyURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 1, textEncodingName: "")
    }

    private func anyHTTPURLResponse(statusCode: Int = 0) -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: "", headerFields: nil)!
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "test", code: 0, userInfo: nil)
    }
}
