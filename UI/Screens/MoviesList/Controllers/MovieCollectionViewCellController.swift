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
    var cell: MovieCollectionViewCell?
    var viewModel: MovieViewModel?
    
    public init(viewModel: MovieViewModel) {
        self.viewModel = viewModel
    }
    
    func view(at indexPath: IndexPath, collectionView: UICollectionView) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MovieCollectionViewCell
        if let viewModel = viewModel {
            cell?.set(viewModel: viewModel)
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
