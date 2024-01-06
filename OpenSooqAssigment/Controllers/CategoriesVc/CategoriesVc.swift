//
//  CategoriesVc.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 28/12/2023.
//

import UIKit
import RealmSwift

// MARK: - CategoriesVc
class CategoriesVc: UIViewController {
    
    private var categoriesData: List<CategoryModelRealm>?
    private var filteredData: List<CategoryModelRealm>?

    let viewModel = HomeViewModel()
    var isLoading: Bool = false
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search Categories"
        searchBar.delegate = self
        return searchBar
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        fetchData()
    }
    
    private func setUpViews() {
        setUpSearchBar()
        registerCells()
        setUpCollectionView()
    }
    
    private func setUpSearchBar() {
        view.addSubview(searchBar)
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor,padding: UIEdgeInsets(top: 0, left: 10, bottom: 10, right: -10))
    }
    
    private func registerCells() {
        collectionView.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
    }
    
    private func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.anchor(top: searchBar.bottomAnchor,leading: view.leadingAnchor,bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    private func fetchData() {
        
        LoadingViewManager.showLoader(in: self)
        viewModel.onCategoriesUpdate = {[weak self] categories in
            guard let strongSelf = self else { return }
            strongSelf.categoriesData = categories.items
            strongSelf.filteredData = categories.items
            strongSelf.updateUI()
        }
        
        viewModel.onLoadingStateChanged = {[weak self] isLoading in
            guard let strongSelf = self else { return }
            strongSelf.isLoading = isLoading
            DispatchQueue.main.async {
                if !isLoading {
                    LoadingViewManager.hideLoader(in: strongSelf)
                }
            }
        }
        
        viewModel.onError = { [weak self] error in
            guard let strongSelf = self else { return }
            AlertManager.showAlert(in: strongSelf, title: "Error!", message: "\(error.localizedDescription)")
        }
        
        viewModel.onSavingError = { [weak self] error in
            guard let strongSelf = self else { return }
            AlertManager.showAlert(in: strongSelf, title: "Error!", message: "\(error.localizedDescription)")
        }
        
        viewModel.fetchCategories()
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegates & DataSource
extension CategoriesVc: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as? CategoriesCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let model = filteredData?[indexPath.item] else { return UICollectionViewCell()}
        cell.configure(with: model)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let subCategories = categoriesData?[indexPath.item].subCategories {
            let itemList = List<CategoryModelRealm>()
            for category in subCategories {
                itemList.append(category)
            }
            let newViewController = SubCategoriesVc(subCategories: itemList)
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
}

// MARK: - UISearchBarDelegate
extension CategoriesVc: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        if searchText.isEmpty {
            filteredData = categoriesData
        } else {
            if let categoriesData = categoriesData {
                let filteredArray = Array(categoriesData).filter { (category: CategoryModelRealm) -> Bool in
                    return category.label_en?.lowercased().contains(searchText.lowercased()) ?? false
                }
                
                filteredData?.removeAll()
                filteredData?.append(objectsIn: filteredArray)
            } else {
            }
        }
        collectionView.reloadData()
    }
}
