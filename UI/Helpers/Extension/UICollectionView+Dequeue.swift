//
//  UICollectionView+Dequeue.swift
//  UI
//
//  Created by Luiz Hammerli on 26/02/22.
//

import UIKit

extension UICollectionReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    // MARK: - Cell
    func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier : \(T.identifier)")
        }

        return cell
    }

    // MARK: - SupplementaryView
    func register<T: UICollectionReusableView>(_: T.Type, ofKind kind: String) {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.identifier)
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, indexPath: IndexPath) -> T {
        guard let supplementaryView = dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: T.identifier,
                                                                       for: indexPath) as? T else {
            fatalError("Could not dequeue supplementary view with identifier: \(T.identifier)")
        }
        return supplementaryView
    }
}
