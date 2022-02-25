//
//  TestHelpers.swift
//  InfraTests
//
//  Created by Luiz Hammerli on 24/02/22.
//

import Foundation

func anyURLResponse() -> URLResponse {
    return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 1, textEncodingName: "")
}

func anyHTTPURLResponse(statusCode: Int = 0) -> HTTPURLResponse {
    return HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: "", headerFields: nil)!
}

func anyNSError() -> NSError {
    return NSError(domain: "test", code: 0, userInfo: nil)
}
