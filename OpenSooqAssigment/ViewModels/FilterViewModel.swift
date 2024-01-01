//
//  FilterViewModel.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 29/12/2023.
//

import Foundation
class FilterViewModel {
    
    var onAttributesUpdate: ((SearchFlow,Set<FieldsLabel>, AttributesOptionsData) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onError: ((Error) -> Void)?

    private var attributesTask1: SearchFlow?
    private var attributesTask2: AttributesOptionsData?
    private var attributesTask3: [FieldsLabel]?
    private var selectedCategories: Set<Option> = []
    
    private var isLoading = false {
        didSet {
            onLoadingStateChanged?(isLoading)
        }
    }
    
    func fetchData(categoryId: Int) {
        isLoading = true
        
        let jsonParser = JSONParser()
        jsonParser.fetchDynamicAttributes(categoryId: categoryId) { [weak self] attributesTask1, attributesTask2, attributesTask3, error in
            guard let self = self else { return }
            self.isLoading = false
            if let error = error {
                self.onError?(error)
            } else {
                if let attributes1 = attributesTask1, let attributes2 = attributesTask2, let attributes3 = attributesTask3 {
                    self.onAttributesUpdate?(attributes1, attributes3, attributes2)
                }
            }
        }
    }
    
    func addToSelectedCategories(option: Option) {
        self.selectedCategories.insert(option)
    }
}
