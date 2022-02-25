//
//  URLSessionHttpClient.swift
//  Infra
//
//  Created by Luiz Diniz Hammerli on 24/02/22.
//

import Foundation
import Data

public final class URLSessionHttpGetClient: HttpGetClient {
    private let urlSession: URLSession
    
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
