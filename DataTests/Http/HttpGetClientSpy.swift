//
//  HttpGetClientSpy.swift
//  DataTests
//
//  Created by Luiz Diniz Hammerli on 24/02/22.
//

import Foundation
import Data

final class HttpGetClientSpy: HttpGetClient {
    private var messages: [(url: URL, completion: (HttpGetClient.Result) -> Void)] = []

    var requestedURLS: [URL] {
        return messages.map { $0.url }
    }

    var messagesCount: Int {
        messages.count
    }

    func get(_ url: URL, completion: @escaping (HttpGetClient.Result) -> Void) {
        messages.append((url, completion))
    }

    func complete(with expectedResult: HttpGetClient.Result, at index: Int = 0) {
        messages[index].completion(expectedResult)
    }
}
