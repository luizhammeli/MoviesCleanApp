//
//  HttpGetClientTests.swift
//  InfraTests
//
//  Created by Luiz Diniz Hammerli on 24/02/22.
//

import Foundation
import XCTest
import Data

public final class URLSessionHttpGetClient: HttpGetClient {
    let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    public func get(_ url: URL, completion: @escaping (HttpGetClient.Result) -> Void) {
        let task = urlSession.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if error == nil { return completion(.failure(.serverError)) }
            
            guard let response = response as? HTTPURLResponse, let data = data else { return completion(.failure(.badRequest)) }
            let result = self.checkResponseData(response: response, data: data)
            completion(result)
        }
        task.resume()
    }
    
    private func checkResponseData(response: HTTPURLResponse, data: Data) -> HttpGetClient.Result {
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
    
    func test_fetch_shouldRequestWithCorrectURLForGetMethod() {        
    }
}

extension HttpGetClientTests {
    func makeSUT() -> URLSessionHttpGetClient {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolStub.self]
        let sut = URLSessionHttpGetClient(urlSession: URLSession(configuration: configuration))
        return sut
    }
}
