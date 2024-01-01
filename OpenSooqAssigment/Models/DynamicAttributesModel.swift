//
//  DynamicAttributesModel.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 29/12/2023.
//

import Foundation

// MARK: - DynamicAttributesModel
struct DynamicAttributesModel: Codable {
    let success: Bool
    let result: Result
}

// MARK: - Result
struct Result: Codable {
    let status: Int
    let data: DataClass
    let hash: String
}

// MARK: - DataClass
struct DataClass: Codable {
    let searchFlow: [SearchFlow]
    let fieldsLabels: Set<FieldsLabel>

    enum CodingKeys: String, CodingKey {
        case searchFlow = "search_flow"
        case fieldsLabels = "fields_labels"
    }
}

// MARK: - FieldsLabel
struct FieldsLabel: Codable,Hashable {
    let fieldName, labelAr, labelEn: String

    enum CodingKeys: String, CodingKey {
        case fieldName = "field_name"
        case labelAr = "label_ar"
        case labelEn = "label_en"
    }
}

// MARK: - SearchFlow
struct SearchFlow: Codable {
    let categoryID: Int
    let order: [String]

    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case order
    }
}
