//
//  SectionHeaderCollectionViewCell.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 29/12/2023.
//

import UIKit

class SectionHeaderCollectionViewCell: UICollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
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
        contentView.addSubview(titleLabel)
        titleLabel.anchor(leading: contentView.leadingAnchor, centerY: contentView.centerYAnchor,padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
    }
    
    func setUpCell(title: String) {
        self.titleLabel.text = title
    }
}
