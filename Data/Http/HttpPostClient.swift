//
//  HttpPostClient.swift
//  Data
//
//  Created by Luiz Diniz Hammerli on 24/02/22.
//

import Foundation

public protocol HttpPostClient {
    func post(to url: URL, with data: Data?, completion: @escaping (Result<Data?, HttpError>) -> Void)
}
