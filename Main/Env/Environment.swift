//
//  Environment.swift
//  Main
//
//  Created by Luiz Hammerli on 26/02/22.
//

import Foundation

final class Environment {
    enum Variables: String {
        case apiURL = "API_BASE_URL"
        case apiImageBaseURL = "API_IMAGE_BASE_URL"
        case apiKey = "API_KEY"
    }
    
    static func variable(for key: Variables) -> String {
        return Bundle.main.infoDictionary?[key.rawValue] as! String
    }
}
