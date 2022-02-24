//
//  DomainError.swift
//  Domain
//
//  Created by Luiz Diniz Hammerli on 24/02/22.
//

import Foundation

public enum DomainError: Error {
    case unexpected
    case invalidData
    case emailInUse
    case expiredSession
}
