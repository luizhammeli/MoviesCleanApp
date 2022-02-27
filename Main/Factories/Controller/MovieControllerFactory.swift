//
//  MovieControllerFactory.swift
//  Main
//
//  Created by Luiz Hammerli on 26/02/22.
//

import Foundation
import UIKit
import Domain
import Presentation
import UI

func makeMovieController(movieLoader: MovieLoader) -> MoviesCollectionViewController {
    let controller = MoviesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    let baseURL = Environment.variable(for: .apiImageBaseURL)
    let presenter = MovieViewPresenter(imageBaseURL: baseURL,
                                       loader: MainQueueDispatchDecorator(instance: movieLoader),
                                       loadingView: WeakVarProxy(controller),
                                       movieView: WeakVarProxy(controller),
                                       alertView: WeakVarProxy(controller))
    controller.loadMovies = presenter.loadMovies
    return controller
}
