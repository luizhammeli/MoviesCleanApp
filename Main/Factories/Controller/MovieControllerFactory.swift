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

func makeMovieController(movieLoader: MovieLoader, imageBaseURL: String = Environment.variable(for: .apiImageBaseURL) ) -> MoviesCollectionViewController {
    let controller = MoviesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())    
    let presenter = MovieViewPresenter(imageBaseURL: imageBaseURL,
                                       loader: MainQueueDispatchDecorator(instance: movieLoader),
                                       loadingView: WeakVarProxy(controller),
                                       movieView: WeakVarProxy(controller),
                                       alertView: WeakVarProxy(controller))
    controller.loadMovies = presenter.loadMovies
    return controller
}
