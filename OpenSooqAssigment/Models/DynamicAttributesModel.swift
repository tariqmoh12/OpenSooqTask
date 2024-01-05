//
//  DynamicAttributesModel.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 29/12/2023.
//

import Foundation
import RealmSwift

// MARK: - DynamicAttributesModel
class DynamicAttributesModel: Object,Codable {
    @Persisted var success: Bool
    @Persisted var result: Result?
}

// MARK: - Result
class Result: Object,Codable {
    @Persisted var status: Int
    @Persisted var data: DataClass?
}

// MARK: - DataClass
class DataClass: Object,Codable {
    @Persisted(primaryKey: true) var id: Int?
    @Persisted var searchFlow = List<SearchFlow>()
    @Persisted var fieldsLabels = List<FieldsLabel>()
    enum CodingKeys: String, CodingKey {
           case searchFlow = "search_flow"
           case fieldsLabels = "fields_labels"
       }
}

// MARK: - FieldsLabel
class FieldsLabel: Object,Codable {
    @Persisted var fieldName: String = ""
    @Persisted var labelAr: String = ""
    @Persisted var labelEn: String = ""
    enum CodingKeys: String, CodingKey {
         case fieldName = "field_name"
         case labelAr = "label_ar"
         case labelEn = "label_en"
     }

}

// MARK: - SearchFlow
class SearchFlow: Object,Codable {
    @Persisted var categoryID: Int
    @Persisted var order = List<String>()
    enum CodingKeys: String, CodingKey {
           case categoryID = "category_id"
           case order
       }
}
