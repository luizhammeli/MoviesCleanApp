//
//  WeakVarProxy.swift
//  Main
//
//  Created by Luiz Hammerli on 26/02/22.
//

import Foundation
import Presentation

final class WeakVarProxy<T: AnyObject> {
    private weak var instance: T?
    
    init(_ instance: T) {
        self.instance = instance
    }
}

extension WeakVarProxy: MovieLoadingView where T: MovieLoadingView {
    func display(viewModel: MovieLoadingViewModel) {
        instance?.display(viewModel: viewModel)
    }
}

extension WeakVarProxy: MovieAlertView where T: MovieAlertView {
    func display(viewModel: MovieAlertViewModel) {
        instance?.display(viewModel: viewModel)
    }
}

extension WeakVarProxy: MovieView where T: MovieView {
    func display(movies: [MovieViewModel]) {
        instance?.display(movies: movies)
    }
}
