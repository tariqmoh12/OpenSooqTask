//
//  NumericInnerCollectionViewCell.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 02/01/2024.
//

import UIKit

class NumericInnerCollectionViewCell: UICollectionViewCell {
    
    var model: Option? {
        didSet {
            setupCell()
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
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
        
        contentView.addSubview(arrowImageView)
        arrowImageView.anchor( trailing: contentView.trailingAnchor,centerY: contentView.centerYAnchor,padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20))
        
        contentView.addSubview(self.titleLabel)
        titleLabel.anchor(
            leading: self.contentView.leadingAnchor,
            centerY: self.contentView.centerYAnchor,
            padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0))
    }
    
    func setupCell() {
        self.titleLabel.text = model?.labelEn
    }
}
