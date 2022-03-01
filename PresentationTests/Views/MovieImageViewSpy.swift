//
//  MovieImageViewSpy.swift
//  PresentationTests
//
//  Created by Luiz Diniz Hammerli on 01/03/22.
//

import Presentation

final class MovieImageViewSpy: MovieLoadingView, MovieImageView {
    enum Messages: Equatable, Hashable {
        case display(isLoading: Bool)
        case displayImage(String?)
    }

    typealias Image = ImageStub
    var messages: [Messages] = []

    func display(viewModel: MovieLoadingViewModel) {
        messages.append(.display(isLoading: viewModel.isLoading))
    }

    func display(image: Image?) {
        messages.append(.displayImage(image?.id))
    }
}
