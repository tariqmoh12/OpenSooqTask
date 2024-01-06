//
//  NumericCollectionViewCell.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 02/01/2024.
//

import UIKit
import RealmSwift

// MARK: - NumericCollectionViewCell
class NumericCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: SelectOptionProtocol?
    private var options: List<Option>?

    lazy var innerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NumericInnerCollectionViewCell.self, forCellWithReuseIdentifier: "NumericInnerCollectionViewCell")
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
        innerCollectionView.isScrollEnabled = false
        innerCollectionView.isUserInteractionEnabled = false
    }

    
    func setUpCell(options: List<Option>) {
        self.options = options
    }
}

// MARK: - UICollectionViewDelegates & DataSource
extension NumericCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumericInnerCollectionViewCell", for: indexPath) as? NumericInnerCollectionViewCell else {
               fatalError("Unable to dequeue a reusable cell with identifier YourCellReuseIdentifier")
           }
        cell.model = options?[indexPath.item]
        return cell
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.contentView.frame.width, height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let options = options else { return }
        delegate?.didSelect(option: options[indexPath.item])
    }
}
