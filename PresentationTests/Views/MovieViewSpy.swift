//
//  MovieViewSpy.swift
//  PresentationTests
//
//  Created by Luiz Diniz Hammerli on 25/02/22.
//

import Foundation
import Presentation

final class MovieViewSpy: MovieLoadingView, MovieView, MovieAlertView {
    enum Messages: Equatable, Hashable {
        case display(isLoading: Bool)
        case display(alert: MovieAlertViewModel)
        case display(movies: [MovieViewModel])
    }

    var messages: [Messages] = []

    func display(viewModel: MovieLoadingViewModel) {
        messages.append(.display(isLoading: viewModel.isLoading))
    }

    func display(movies: [MovieViewModel]) {
        messages.append(.display(movies: movies))
    }

    func display(viewModel: MovieAlertViewModel) {
        messages.append(.display(alert: viewModel))
    }
}
