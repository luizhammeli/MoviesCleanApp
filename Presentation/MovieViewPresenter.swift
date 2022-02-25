//
//  MovieViewPresenter.swift
//  Presentation
//
//  Created by Luiz Diniz Hammerli on 25/02/22.
//

import Foundation
import Domain

public final class MovieViewPresenter {
    private let imageBaseURL: String
    private let loader: MovieLoader
    
    private let loadingView: MovieLoadingView
    private let alertView: MovieAlertView
    private let movieView: MovieView
    
    public init(imageBaseURL: String, loader: MovieLoader, loadingView: MovieLoadingView, movieView: MovieView, alertView: MovieAlertView) {
        self.loader = loader
        self.loadingView = loadingView
        self.movieView = movieView
        self.imageBaseURL = imageBaseURL
        self.alertView = alertView
    }
    
    public func loadMovies() {
        loadingView.display(viewModel: .init(isLoading: true))
        loader.load { [weak self] result in
            guard let self = self else { return }
            self.loadingView.display(viewModel: .init(isLoading: false))
            
            if let movies = try? result.get() {
                self.movieView.display(movies: self.toMoviesViewModel(movies: movies))
            } else {
                self.alertView.display(viewModel: .init(title: "Erro", message: "Ocorreu um erro inesperado."))
            }
        }
    }
    
    private func toMoviesViewModel(movies: [Movie]) -> [MovieViewModel] {
        movies.compactMap { movie in
            guard let url = URL(string: "\(imageBaseURL + movie.posterPath)") else { return nil }
            return .init(title: movie.title, imageURL: url)
        }
    }
}
