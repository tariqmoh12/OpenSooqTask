//
//  CircularCollectionViewCell.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 29/12/2023.
//

import UIKit

class CircularCollectionViewCell: UICollectionViewCell {
    
    var model: Option? {
        didSet {
           setUpImageView()
        }
    }
    
    lazy var circularView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = contentView.frame.width / 2
        view.layer.borderWidth = 0.3
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.clipsToBounds = true
        return view
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
        contentView.addSubview(circularView)
        circularView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor)
        
        circularView.addSubview(iconImageView)
        iconImageView.anchor(top: circularView.topAnchor, leading: circularView.leadingAnchor, bottom: circularView.bottomAnchor, trailing: circularView.trailingAnchor)
    }
    
    private func setUpImageView() {
        guard let model = model else { return }
        if let imageUrl = model.optionImg, let url = URL(string: imageUrl) {
            ImageLoader.loadImage(from: url, into: iconImageView)
        } else {
            iconImageView.image = UIImage(named: "default-placeholder")
        }
    }
}
