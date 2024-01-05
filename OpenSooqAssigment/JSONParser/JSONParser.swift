//
//  JSONParser.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 28/12/2023.
//

import Foundation
import UIKit
import RealmSwift
class JSONParser {
    
    class func parseDataFromJson(completion: @escaping (CategoriesModelRealm?, Error?) -> Void) {
        do {
            if let path = Bundle.main.path(forResource: "categoriesAndsubCategories", ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let resultData = try JSONDecoder().decode(ResultsModelRealm.self, from: data)
                completion(resultData.result?.data, nil)
            } else {
                let error = NSError(domain: "YourDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "Unable to find JSON file"])
                completion(nil, error)
            }
        } catch {
            completion(nil, error)
        }
    }
    
    func fetchDynamicAttributes(categoryId: Int, completion: @escaping (SearchFlow?, AttributesOptionsData?, List<FieldsLabel>?, Error?) -> Void) {
        
        var searchFlow: SearchFlow?
        var attributesOptionsData: AttributesOptionsData?
        var fieldsLabel: List<FieldsLabel>?
        let dispatchGroup = DispatchGroup()
        let isAttributesHaveBeenSaved = UserDefaults.standard.bool(forKey: "isAttributesHaveBeenSaved")
        let allSavedAttributes: Results<DataClass> = RealmManager.shared.getObjects(DataClass.self)
        let allSavedOptions: Results<AttributesOptionsModel> = RealmManager.shared.getObjects(AttributesOptionsModel.self)
        
        if !isAttributesHaveBeenSaved {
            dispatchGroup.enter()
            DispatchQueue.global().async {
                do {
                    if let path = Bundle.main.path(forResource: "dynamic-attributes-assign-raw", ofType: "json") {
                        let content = try String(contentsOfFile: path)
                        if let data = content.data(using: .utf8) {
                            
                            let resultData = try JSONDecoder().decode(DynamicAttributesModel.self, from: data)
                            DispatchQueue.main.async {
                                searchFlow = resultData.result?.data?.searchFlow.first(where: { $0.categoryID == categoryId })
                                fieldsLabel = resultData.result?.data?.fieldsLabels
                                if let dataToSave = resultData.result?.data {
                                    DataSaver.saveData(dataToSave, fileNum: 1)
                                }
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
                            let resultData = try JSONDecoder().decode(AttributesOptionsModel.self, from: data)
                            DispatchQueue.main.async {
                                attributesOptionsData = resultData.result?.data
                                if let dataToSave = resultData.result?.data {
                                    DataSaver.saveData(resultData, fileNum: 2)
                                }
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
        } else {
            if let firstObj = allSavedAttributes.first, let firstOptionsObj = allSavedOptions.first{
                searchFlow = firstObj.searchFlow.first(where: { $0.categoryID == categoryId })
                fieldsLabel = firstObj.fieldsLabels
                attributesOptionsData = firstOptionsObj.result?.data
                completion(searchFlow, attributesOptionsData, fieldsLabel, nil)
            }
        }
    }
}
