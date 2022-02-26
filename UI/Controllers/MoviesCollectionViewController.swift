//
//  MoviesCollectionViewController.swift
//  UI
//
//  Created by Luiz Hammerli on 26/02/22.
//

import UIKit

public final class MoviesCollectionViewController: UICollectionViewController {
    private let loadMovies: () -> Void
    
    public init(layout: UICollectionViewLayout, loadMovies: @escaping () -> Void) {
        self.loadMovies = loadMovies
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        collectionView.backgroundColor = .red
    }
}
