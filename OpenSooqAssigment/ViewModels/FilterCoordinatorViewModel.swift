//
//  FilterCoordinatorViewModel.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 30/12/2023.
//

import Foundation
class FilterCoordinatorViewModel {
    
    var onDataUpdate: ((AttributesOptionsData) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onError: ((Error) -> Void)?
    
    private var AttributedOptions: AttributesOptionsData? {
        didSet {
            onDataUpdate?(AttributedOptions!)
        }
    }
    
    private var isLoading = false {
        didSet {
            onLoadingStateChanged?(isLoading)
        }
    }
    
    func fetchData() {
        do {
            isLoading = true
            if let path = Bundle.main.path(forResource: "dynamic-attributes-and-options-raw", ofType: "json") {
                do {
                    let content = try String(contentsOfFile: path)
                    if let data = content.data(using: .utf8) {
                        let yourModel = try JSONDecoder().decode(AttributesOptionsModel.self, from: data)
                        DispatchQueue.main.async {
                            self.AttributedOptions = yourModel.result.data
                            self.isLoading = false
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.onError?(error)
                    }
                }
            }
        }
    }
}
