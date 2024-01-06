//
//  SectionFooterCollectionViewCell.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 30/12/2023.
//

import UIKit

// MARK: - SectionFooterCollectionViewCell
class SectionFooterCollectionViewCell: UICollectionViewCell {
    
    lazy var arrowImageView: UIImageView = {
         let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
         imageView.contentMode = .scaleAspectFit
         return imageView
     }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
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
        arrowImageView.anchor( trailing: contentView.trailingAnchor,centerY: contentView.centerYAnchor,padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10))
        
        contentView.addSubview(titleLabel)
        titleLabel.anchor(leading: contentView.leadingAnchor, centerY: contentView.centerYAnchor,padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5))
    }
    
    func setUpCell(title: String) {
        self.titleLabel.text = title
    }
}
