//
//  MoviesCollectionViewController.swift
//  UI
//
//  Created by Luiz Hammerli on 26/02/22.
//

import UIKit
import Presentation

public final class MoviesCollectionViewController: UICollectionViewController {
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    public var loadMovies: (() -> Void)?
    public var loadCells: (([MovieViewModel]) -> [MovieCollectionViewCellController])?
    
    private var movies: [MovieCollectionViewCellController] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollectionView()
        loadMovies?()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func registerCells() {
        self.collectionView?.register(MovieCollectionViewCell.self)
        self.collectionView?.register(UICollectionViewCell.self, ofKind: UICollectionView.elementKindSectionFooter)
    }
    
    private func setupCollectionView() {
        registerCells()        
        title = MovieViewPresenter.title
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return movies[indexPath.item].view(at: indexPath, collectionView: collectionView)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return movies[indexPath.item].sizeForItem(parentViewSize: view.frame.size)
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        movies[indexPath.item].cancelLoad()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 8, bottom: 10, right: 8)
    }
}

// MARK: - CodeView
extension MoviesCollectionViewController: CodeView {
    public func buildViewHierarchy() {
        view.addSubview(activityIndicator)
    }
    
    public func setupConstraints() {
        activityIndicator.centerInSuperview()
    }
    
    public func setupAdditionalConfiguration() {}
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MoviesCollectionViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 0)
    }
}

// MARK: - MovieAlertView
extension MoviesCollectionViewController: MovieAlertView {
    public func display(viewModel: MovieAlertViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

// MARK: - MovieAlertView
extension MoviesCollectionViewController: MovieLoadingView {
    public func display(viewModel: MovieLoadingViewModel) {
        if viewModel.isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

// MARK: - MovieView
extension MoviesCollectionViewController: MovieView {
    public func display(movies: [MovieViewModel]) {
        self.movies = loadCells?(movies) ?? []
    }
}

