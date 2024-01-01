//
//  HomeViewModel.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 28/12/2023.
//

import Foundation
class HomeViewModel {
    
    var onCategoriesUpdate: ((CategoriesModel) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onError: ((Error) -> Void)?
    let jsonParser = JSONParser()

    private var Categories: CategoriesModel? {
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
           JSONParser.parseDataFromJson { (categoriesModel, error) in
               if let error = error {
                   DispatchQueue.main.async {
                       self.isLoading = false
                       print(error.localizedDescription)
                       self.onError?(error)
                   }
               } else if let categoriesModel = categoriesModel {
                   DispatchQueue.main.async {
                       self.Categories = categoriesModel
                       self.isLoading = false
                   }
               }
           }
       }
}
