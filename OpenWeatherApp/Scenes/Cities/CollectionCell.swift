//
//  CollectionCell.swift
//  OpenWeatherApp
//
//  Created by Hugo Hernando Bernal Palacio on 7/12/20.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    static let id = "cellId"

    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    override func layoutSubviews() {
        super.contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            label.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 1),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 1)
        ])
    }
}
