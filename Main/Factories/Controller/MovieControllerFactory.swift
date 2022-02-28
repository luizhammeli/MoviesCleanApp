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

func makeMovieController(movieLoader: MovieLoader,
                         imageLoader: MovieImageDataLoader,
                         imageBaseURL: String = Environment.variable(for: .apiImageBaseURL)) -> MoviesCollectionViewController {
    let controller = MoviesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())    
    let presenter = MovieViewPresenter(imageBaseURL: imageBaseURL,
                                       loader: MainQueueDispatchDecorator(instance: movieLoader),
                                       loadingView: WeakVarProxy(controller),
                                       movieView: WeakVarProxy(controller),
                                       alertView: WeakVarProxy(controller))
    controller.loadMovies = presenter.loadMovies
    controller.loadCells = makeCellController(imageLoader: imageLoader)
    return controller
}

func makeCellController(imageLoader: MovieImageDataLoader) -> (([MovieViewModel]) -> [MovieCollectionViewCellController]) {
    return { movies in
        movies.map { MovieCollectionViewCellController(viewModel: $0) }
    }
}
