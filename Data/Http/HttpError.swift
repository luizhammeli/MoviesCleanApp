//
//  HttpError.swift
//  Data
//
//  Created by Luiz Diniz Hammerli on 24/02/22.
//

import Foundation

public enum HttpError: Error {
    case noConnectivity
    case forbidden
    case unauthorized
    case serverError
    case badRequest
    case invalidResponse
}
