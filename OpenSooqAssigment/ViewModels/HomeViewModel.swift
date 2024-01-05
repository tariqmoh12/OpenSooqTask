//
//  HomeViewModel.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 28/12/2023.
//

import Foundation
import RealmSwift


class HomeViewModel {
    
    var onCategoriesUpdate: ((CategoriesModelRealm) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onError: ((Error) -> Void)?
    var onSavingError: ((Error) -> Void)?
    let jsonParser = JSONParser()
    let allSavedCategories: Results<CategoriesModelRealm> = RealmManager.shared.getObjects(CategoriesModelRealm.self)

    private var Categories: CategoriesModelRealm? {
        didSet {
            onCategoriesUpdate?(Categories!)
        }
    }

    private var isLoading = false {
        didSet {
            onLoadingStateChanged?(isLoading)
        }
    }
    
    func fetchCategories() {
        isLoading = true
        let categoriesHaveBeenSaved = UserDefaults.standard.bool(forKey: "isCategoriesHaveBeenSaved")
        if !categoriesHaveBeenSaved {
            JSONParser.parseDataFromJson {[weak self] (categoriesModel, error) in
                guard let strongSelf = self else { return }
                if let error = error {
                    DispatchQueue.main.async {
                        strongSelf.isLoading = false
                        print(error.localizedDescription)
                        strongSelf.onError?(error)
                    }
                } else if let categoriesModel = categoriesModel {
                    DispatchQueue.main.async {
                        strongSelf.Categories = categoriesModel
                        strongSelf.saveCetgories(cateogies: categoriesModel)
                        strongSelf.isLoading = false
                    }
                }
            }
        } else {
            self.isLoading = false
            let categories = CategoriesModelRealm()
            for category in allSavedCategories.elements {
                categories.items.append(objectsIn: category.items)
            }
            self.Categories = categories
        }
       }
    
    private func saveCetgories(cateogies:CategoriesModelRealm) {
        RealmManager.shared.saveObject(cateogies) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success:
                UserDefaults.standard.set(true, forKey: "isCategoriesHaveBeenSaved")
                UserDefaults.standard.synchronize()
            case .failure(let error):
                strongSelf.onSavingError?(error)
            }
        }
    }
}
