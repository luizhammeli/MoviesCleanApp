//
//  MovieImagePresenter.swift
//  Presentation
//
//  Created by Luiz Diniz Hammerli on 28/02/22.
//

import Foundation
import Domain

public protocol MovieImageView {
    associatedtype Image: Equatable
    func display(image: Image?)
}

public final class MovieImagePresenter<View: MovieImageView, Image> where View.Image == Image {
    let loader: MovieImageDataLoader
    let view: View
    let alertView: MovieLoadingView
    let imageTransformer: (Data) -> Image?
    
    public init(loader: MovieImageDataLoader, alertView: MovieLoadingView, view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.loader = loader
        self.alertView = alertView
        self.view = view
        self.imageTransformer = imageTransformer
    }
    
    public func load(url: URL) {
        alertView.display(viewModel: .init(isLoading: true))
        loader.loadFeedImageData(from: url) { [weak self] result in
            guard let self = self else { return }
            self.alertView.display(viewModel: .init(isLoading: false))
            
            guard let data = try? result.get() else { return self.view.display(image: nil) }
            self.view.display(image: self.imageTransformer(data))
        }
    }
}
