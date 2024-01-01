//
//  ListOfStringsCollectionViewCell.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 29/12/2023.
//

import UIKit

class ListOfStringsCollectionViewCell: UICollectionViewCell {
    
    var model: Option? {
        didSet {
            setupCell()
        }
    }
    
    lazy var rectangularView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderWidth = 0.3
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
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
        contentView.addSubview(rectangularView)
        rectangularView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor)
        
        rectangularView.addSubview(titleLabel)
        titleLabel.anchor(top: rectangularView.topAnchor, leading: rectangularView.leadingAnchor, bottom: rectangularView.bottomAnchor, trailing: rectangularView.trailingAnchor)
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.anchor(
            leading: self.contentView.leadingAnchor,
            trailing: self.contentView.trailingAnchor,
            centerY: self.contentView.centerYAnchor,
            padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -16))
    }
    
    func setupCell() {
        self.titleLabel.text = model?.labelEn
    }
}
