//
//  AttributesOptionsModel.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 29/12/2023.
//

import Foundation

// MARK: - DynamicAttributesModel
struct AttributesOptionsModel: Codable {
    let success: Bool
    let result: AttributesOptionsResult
}

// MARK: - Result
struct AttributesOptionsResult: Codable {
    let status: Int
    let data: AttributesOptionsData
    let hash: String
}

// MARK: - DataClass
struct AttributesOptionsData: Codable,Hashable {
    let fields: [Field]
    let options: [Option]
    
    static func == (lhs: AttributesOptionsData, rhs: AttributesOptionsData) -> Bool {
        return false
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(fields)
    }
}

// MARK: - Field
struct Field: Codable,Hashable {
    let id: Int
    let name: String
    let dataType: DataType
    let parentID: Int
    let parentName: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case dataType = "data_type"
        case parentID = "parent_id"
        case parentName = "parent_name"
    }
}

enum DataType: String, Codable {
    case boolean = "boolean"
    case integer = "integer"
    case listNumeric = "list_numeric"
    case listString = "list_string"
    case listStringBoolean = "list_string_boolean"
    case listStringIcon = "list_string_icon"
    case string = "string"
}

// MARK: - Option
struct Option: Codable,Hashable {
    let id, fieldID, label, labelEn: String
    let value: String
    let optionImg: String?
    let hasChild: String
    let parentID: String?
    let order: String

    enum CodingKeys: String, CodingKey {
        case id
        case fieldID = "field_id"
        case label
        case labelEn = "label_en"
        case value
        case optionImg = "option_img"
        case hasChild = "has_child"
        case parentID = "parent_id"
        case order
    }
}
