//
//  CategoriesCollectionViewCell.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 28/12/2023.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        contentView.addSubview(iconImageView)
        iconImageView.anchor(top: contentView.topAnchor,leading: contentView.leadingAnchor,bottom: contentView.bottomAnchor,padding: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0), size: CGSize(width: 50, height: 50))
        contentView.addSubview(titleLabel)
        titleLabel.anchor(top: contentView.topAnchor,leading: iconImageView.trailingAnchor,bottom: contentView.bottomAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
    }
    
    func configure(with model: CategoryModel) {
        titleLabel.text = model.labelEn
        if let imageUrl = URL(string: model.icon) {
            ImageLoader.loadImage(from: imageUrl, into: iconImageView)
        }
    }
}
