//
//  CodeView.swift
//  UI
//
//  Created by Luiz Hammerli on 26/02/22.
//

import Foundation

public protocol CodeView {
    func buildViewHierarchy()
    func setupConstraints()
    func setupAdditionalConfiguration()
    func setupViews()
}

extension CodeView {
    public func setupViews() {
        buildViewHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }
}
