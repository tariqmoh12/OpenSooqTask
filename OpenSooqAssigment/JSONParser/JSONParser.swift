//
//  JSONParser.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 28/12/2023.
//

import Foundation
import UIKit
class JSONParser {
    
    class func parseDataFromJson(completion: @escaping (CategoriesModel?, Error?) -> Void) {
        do {
            if let path = Bundle.main.path(forResource: "categoriesAndsubCategories", ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let yourModel = try JSONDecoder().decode(ResultsModel.self, from: data)
                completion(yourModel.result.data, nil)
            } else {
                let error = NSError(domain: "YourDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "Unable to find JSON file"])
                completion(nil, error)
            }
        } catch {
            completion(nil, error)
        }
    }
    
    func fetchDynamicAttributes(categoryId: Int, completion: @escaping (SearchFlow?, AttributesOptionsData?, Set<FieldsLabel>?, Error?) -> Void) {
        
        var searchFlow: SearchFlow?
        var attributesOptionsData: AttributesOptionsData?
        var fieldsLabel: Set<FieldsLabel>?
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        DispatchQueue.global().async {
            do {
                if let path = Bundle.main.path(forResource: "dynamic-attributes-assign-raw", ofType: "json") {
                    let content = try String(contentsOfFile: path)
                    if let data = content.data(using: .utf8) {
                        let yourModel = try JSONDecoder().decode(DynamicAttributesModel.self, from: data)
                        DispatchQueue.main.async {
                            searchFlow = yourModel.result.data.searchFlow.first(where: { $0.categoryID == categoryId })
                            fieldsLabel = yourModel.result.data.fieldsLabels
                            dispatchGroup.leave()
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, nil, nil, error)
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.enter()
        DispatchQueue.global().async {
            do {
                if let path = Bundle.main.path(forResource: "dynamic-attributes-and-options-raw", ofType: "json") {
                    let content = try String(contentsOfFile: path)
                    if let data = content.data(using: .utf8) {
                        let yourModel = try JSONDecoder().decode(AttributesOptionsModel.self, from: data)
                        DispatchQueue.main.async {
                            attributesOptionsData = yourModel.result.data
                            dispatchGroup.leave()
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, nil, nil, error)
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(searchFlow, attributesOptionsData, fieldsLabel, nil)
        }
    }
}
