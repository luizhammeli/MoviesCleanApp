//
//  URLProtocolStub.swift
//  InfraTests
//
//  Created by Luiz Diniz Hammerli on 24/02/22.
//

import Foundation

struct Stub {
    let data: Data?
    let response: URLResponse?
    let error: Error?
}

class URLProtocolStub: URLProtocol {
    private static var stub: Stub?
    private static var requestObserver: ((URLRequest) -> Void)?

    static func startIntercepting() {
        URLProtocol.registerClass(URLProtocolStub.self)
    }

    static func stopIntercepting() {
        URLProtocol.unregisterClass(URLProtocolStub.self)
    }

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let requestObserver = URLProtocolStub.requestObserver {
            client?.urlProtocolDidFinishLoading(self)
            return requestObserver(request)
        }

        if let response = URLProtocolStub.stub?.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        }

        if let data = URLProtocolStub.stub?.data {
            client?.urlProtocol(self, didLoad: data)
        }

        if let error = URLProtocolStub.stub?.error {
            client?.urlProtocol(self, didFailWithError: error)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
        URLProtocolStub.requestObserver = nil
    }

    static func observeRequest(with observer: @escaping (URLRequest) -> Void) {
        URLProtocolStub.requestObserver = observer
    }

    static func stub(_ stub: Stub) {
        URLProtocolStub.stub = stub
    }
}
