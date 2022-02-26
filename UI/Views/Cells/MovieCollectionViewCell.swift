//
//  MovieCollectionViewCell.swift
//  UI
//
//  Created by Luiz Hammerli on 26/02/22.
//

import UIKit

final class MovieCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.shadowColor = UIColor.darkGray.withAlphaComponent(0.8).cgColor
        image.layer.shadowRadius = 4
        image.layer.shadowOpacity = 0.5
        image.layer.shadowOffset = CGSize(width: 0, height: 10)
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .vertical
        return stackView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImage(_ url: URL){

//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            DispatchQueue.main.async {
//                self.image.image = UIImage(data: data ?? Data())
//                self.activityIndicator.stopAnimating()
//            }
//        }.resume()
//
//        DispatchQueue.global().async {
//            guard let imageData = try? Data(contentsOf: url) else {return}
//
//            DispatchQueue.main.async {
//                self.image.image = UIImage(data: imageData)
//                self.activityIndicator.stopAnimating()
//            }
//        }
    }
}

// MARK: - CodeView
extension MovieCollectionViewCell: CodeView {
    func buildViewHierarchy() {
        self.addSubview(mainStackView)
    }
    
    func setupConstraints() {
        mainStackView.fillSuperview()
        imageView.anchor(heightAnchor: heightAnchor, heightMultiplier: 0.85, widthAnchor: nil, widthMultiplier: 0)
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .white
    }
}
