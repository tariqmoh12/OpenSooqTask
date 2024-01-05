//
//  CustomOuterCollectionViewCell.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 01/01/2024.
//

import UIKit
import RealmSwift

protocol SelectOptionProtocol: AnyObject {
    func didSelect(option: Option)
}

class CustomOuterCollectionViewCell: UICollectionViewCell {
    weak var delegate: SelectOptionProtocol?
    private var fullModel: FullModel?
    
    lazy var innerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SectionHeaderCollectionViewCell.self, forCellWithReuseIdentifier: "SectionHeaderCollectionViewCell")
        collectionView.register(CustomListCollectionViewCell.self, forCellWithReuseIdentifier: "CustomListCollectionViewCell")
        collectionView.register(SectionFooterCollectionViewCell.self, forCellWithReuseIdentifier: "SectionFooterCollectionViewCell")
        return collectionView
    }()
    
    enum SectionType: Int, CaseIterable {
        case header = 0
        case categoriesList = 1
        case footer = 2
    }
    
    var cellType:CellInnerItemsType?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        contentView.addSubview(innerCollectionView)
        innerCollectionView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor,padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 5))
        innerCollectionView.backgroundColor = .white
    }
    
    func setUpCell(fullModel: FullModel, type:CellInnerItemsType) {
        self.cellType = type
        self.fullModel = fullModel
    }
}

extension CustomOuterCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let type = SectionType(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch type {
        case .header:
           
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionHeaderCollectionViewCell", for: indexPath) as? SectionHeaderCollectionViewCell else {
                   fatalError("Unable to dequeue a reusable cell with identifier YourCellReuseIdentifier")
               }
            if let fullModel = fullModel{
                cell.setUpCell(title: fullModel.title)
            }
            return cell
            
        case .categoriesList:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomListCollectionViewCell", for: indexPath) as? CustomListCollectionViewCell else {
                   fatalError("Unable to dequeue a reusable cell with identifier YourCellReuseIdentifier")
               }
          
            if let fullModel = fullModel {
                cell.setUpCell(type: cellType!, options: fullModel.options ?? List<Option>())
            }
            cell.delegate = self
            return cell
            
        case .footer:
          
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionFooterCollectionViewCell", for: indexPath) as? SectionFooterCollectionViewCell else {
                   fatalError("Unable to dequeue a reusable cell with identifier YourCellReuseIdentifier")
               }
            if let fullModel = fullModel{
                cell.setUpCell(title: fullModel.title)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let type = SectionType(rawValue: indexPath.section), let cellType = cellType else { return CGSize.zero }
        
        switch type {
        case .header:
            return CGSize(width: contentView.frame.width, height: 30)
        case .categoriesList:
            switch cellType {
            case .numeric:
                return CGSize(width: contentView.frame.width, height: 150)
            default:
                return CGSize(width: contentView.frame.width, height: 50)
            }
        case .footer:
            switch cellType {
            case .numeric:
                return CGSize(width: contentView.frame.width, height: 0)
            default:
                return CGSize(width: contentView.frame.width, height: 30)
            }
        }
    }
}

extension CustomOuterCollectionViewCell: SelectOptionProtocol {
    func didSelect(option: Option) {
        delegate?.didSelect(option: option)
    }
}
