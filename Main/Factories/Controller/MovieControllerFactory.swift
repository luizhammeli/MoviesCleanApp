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
    let layout = UICollectionViewFlowLayout()
    return MoviesCollectionViewController(layout: layout, loadMovies: { })
}
