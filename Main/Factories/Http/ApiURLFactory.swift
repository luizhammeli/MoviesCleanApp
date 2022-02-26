//
//  ApiURLFactory.swift
//  Main
//
//  Created by Luiz Hammerli on 26/02/22.
//

import Foundation

func makeMovieApiURL() -> URL {
    return URL(string: "\(Environment.variable(for: .apiURL))")!
}
