//
//  MovieCollectionViewCellController.swift
//  UI
//
//  Created by Luiz Hammerli on 26/02/22.
//

import Foundation
import UIKit
import Presentation

public final class MovieCollectionViewCellController {
    private var cell: MovieCollectionViewCell?
    private var viewModel: MovieViewModel?
    private var image: UIImage?
    public var loadImage: ((URL) -> Void)?
    
    public init(viewModel: MovieViewModel) {
        self.viewModel = viewModel
    }
    
    func view(at indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MovieCollectionViewCell
        if let viewModel = viewModel {
            cell?.set(viewModel: viewModel)
            cell?.activityIndicator.startAnimating()
            loadImage?(viewModel.imageURL)
        }
        return cell!
    }
    
    func sizeForItem(parentViewSize: CGSize) -> CGSize {
        let width = (parentViewSize.width-42) / 3
        return CGSize(width: width, height: (width+(width/2)+40))
    }
    
    func cancelLoad() {
        releaseCellForReuse()
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}

// MARK: - MovieImageView
extension MovieCollectionViewCellController: MovieImageView {
    public typealias Image = UIImage
    
    public func display(image: Image?) {
        cell?.activityIndicator.stopAnimating()
        cell?.setImage(image: image)
    }
}
