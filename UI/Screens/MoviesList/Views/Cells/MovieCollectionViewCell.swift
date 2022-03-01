//
//  MovieCollectionViewCell.swift
//  UI
//
//  Created by Luiz Hammerli on 26/02/22.
//

import UIKit
import Presentation

public final class MovieCollectionViewCell: UICollectionViewCell {
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.shadowColor = UIColor.darkGray.withAlphaComponent(0.8).cgColor
        image.layer.shadowRadius = 4
        image.layer.shadowOpacity = 0.5
        image.layer.shadowOffset = CGSize(width: 0, height: 10)
        image.alpha = 0
        return image
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(viewModel: MovieViewModel) {
        titleLabel.text = viewModel.title
    }

    func setImage(image: UIImage?) {
        self.imageView.image = image
        UIView.animate(withDuration: 0.2) {
            self.imageView.alpha = 1
        }
    }

    func startLoading(loading: Bool) {
        if loading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

// MARK: - CodeView
extension MovieCollectionViewCell: CodeView {
    public func buildViewHierarchy() {
        self.addSubview(mainStackView)
        mainStackView.addSubview(activityIndicator)
    }

    public func setupConstraints() {
        mainStackView.fillSuperview()
        activityIndicator.centerInSuperview()
        imageView.anchor(heightAnchor: heightAnchor, heightMultiplier: 0.8, widthMultiplier: 0)
    }

    public func setupAdditionalConfiguration() {}
}
