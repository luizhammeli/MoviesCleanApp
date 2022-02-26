//
//  HttpGetClient.swift
//  Data
//
//  Created by Luiz Diniz Hammerli on 24/02/22.
//

import Foundation

public protocol HttpClientTask {
    func cancel()
}

public protocol HttpGetClient {
    typealias Result = Swift.Result<Data?, HttpError>
    func get(_ url: URL, completion: @escaping (Result) -> Void)
}
