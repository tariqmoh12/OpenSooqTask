//
//  CustomListCollectionViewCell.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 30/12/2023.
//

import UIKit
import RealmSwift

class CustomListCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: SelectOptionProtocol?
    private var options: List<Option>?
    private var type: CellInnerItemsType?

    lazy var innerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CircularCollectionViewCell.self, forCellWithReuseIdentifier: "CircularCollectionViewCell")
        collectionView.register(ListOfStringsCollectionViewCell.self, forCellWithReuseIdentifier: "ListOfStringsCollectionViewCell")
        collectionView.register(NumericCollectionViewCell.self, forCellWithReuseIdentifier: "NumericCollectionViewCell")        
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        contentView.addSubview(innerCollectionView)
        innerCollectionView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor,padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
    }
    
    func setUpCollectionView(type: CellInnerItemsType) {
        switch type {
        case .icons:
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            innerCollectionView.collectionViewLayout = layout
        case .titles:
            let layout = LeftAlignedCollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
            layout.minimumLineSpacing = 16
            layout.minimumInteritemSpacing = 8
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.allowsMultipleSelection = true
            self.innerCollectionView = collectionView
        case .numeric:
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            innerCollectionView.collectionViewLayout = layout
        }
    }
    
    func setUpCell(type: CellInnerItemsType,options: List<Option>) {
        self.type = type
        self.options = options
        setUpCollectionView(type: type)
    }
}

extension CustomListCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let type = type else { return 0 }
        switch type {
        case .numeric:
            return 1
        default:
            return options?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let type = type else { return UICollectionViewCell() }
        
        switch type {
        case .icons:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircularCollectionViewCell", for: indexPath) as? CircularCollectionViewCell else {
                fatalError("Unable to dequeue a reusable cell with identifier YourCellReuseIdentifier")
            }
            cell.model = options?[indexPath.item]
            return cell
            
        case .titles:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListOfStringsCollectionViewCell", for: indexPath) as? ListOfStringsCollectionViewCell else {
                fatalError("Unable to dequeue a reusable cell with identifier YourCellReuseIdentifier")
            }
            cell.model = options?[indexPath.item]
            return cell
        case .numeric:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumericCollectionViewCell", for: indexPath) as? NumericCollectionViewCell else {
                fatalError("Unable to dequeue a reusable cell with identifier YourCellReuseIdentifier")
            }
            if let options = options {
                cell.setUpCell(options: options)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let type = type else { return CGSize.zero }
        
        switch type {
        case .icons:
            return CGSize(width: 50, height: 50)
        case .titles:
            let font =  UIFont.systemFont(ofSize: 13.0)
            var height: CGFloat = 30.0
            if let hashtagName = options?[indexPath.item].labelEn {
                let itemSize = hashtagName.size(withAttributes: [
                    NSAttributedString.Key.font :  UIFont.systemFont(ofSize: 13.0)
                ])
                var width = itemSize.width+82
                let maxWidth = (UIScreen.main.bounds.width - 32)
                if width > maxWidth {
                    width = maxWidth
                }
                let textHeight = hashtagName.height(width: width, font: font)
                if textHeight > height {
                    height = textHeight + 18
                }
                return CGSize(width: width, height: height)
            } else {
                return CGSize()
            }
        case .numeric:
            return CGSize(width: self.contentView.frame.width, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let options = options else { return }
        delegate?.didSelect(option: options[indexPath.item])
        guard let type = type else { return  }
        switch type {
        case .titles:
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                collectionView.deselectItem(at: selectedIndexPath, animated: false)
            }
            if let cell = collectionView.cellForItem(at: indexPath) as? ListOfStringsCollectionViewCell {
                cell.rectangularView.backgroundColor = .systemBlue
                cell.titleLabel.textColor = .white
            }
        default:
            break
        }
    }
}
