//
//  UIViewController.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 01/01/2024.
//

import UIKit

extension UIViewController {
    func updateUI(for collectionView: UICollectionView) {
        DispatchQueue.main.async {
            collectionView.reloadData()
        }
    }
    
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        return instantiateFromNib()
    }
}
