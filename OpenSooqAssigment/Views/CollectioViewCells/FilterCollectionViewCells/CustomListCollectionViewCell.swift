//
//  CustomListCollectionViewCell.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 30/12/2023.
//

import UIKit


class CustomListCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: SelectOptionProtocol?
    private var options: [Option]?
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
        }
    }
    
    func setUpCell(type: CellInnerItemsType,options: [Option]) {
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
        return options?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let type = type else { return UICollectionViewCell() }
        
        switch type {
        case .icons:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircularCollectionViewCell", for: indexPath) as! CircularCollectionViewCell
            cell.model = options?[indexPath.item]
            return cell
            
        case .titles:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListOfStringsCollectionViewCell", for: indexPath) as! ListOfStringsCollectionViewCell
            cell.model = options?[indexPath.item]
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
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let options = options else { return }
        delegate?.didSelect(option: options[indexPath.item])
    }
}
