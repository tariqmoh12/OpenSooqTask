//
//  AttributesOptionsModel.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 29/12/2023.
//

import Foundation
import RealmSwift

// MARK: - DynamicAttributesModel
class AttributesOptionsModel: Object,Codable {
    @Persisted(primaryKey: true) var id: Int?
    @Persisted var success: Bool
    @Persisted var result: AttributesOptionsResult?
}

// MARK: - Result
class AttributesOptionsResult: Object,Codable {
    @Persisted var status: Int
    @Persisted var data: AttributesOptionsData?
}

// MARK: - DataClass
class AttributesOptionsData: Object,Codable {
    var fields = List<Field>()
    var options = List<Option>()
    enum CodingKeys: String, CodingKey {
         case fields = "fields"
         case options = "options"
     }
}

// MARK: - Field
class Field: Object,Codable {
    @Persisted var id: Int = 0
    @Persisted var name: String
    @Persisted var dataType: String
    @Persisted var parentID: Int
    @Persisted var parentName: String?
    enum CodingKeys: String, CodingKey {
         case id, name
         case dataType = "data_type"
         case parentID = "parent_id"
         case parentName = "parent_name"
     }

}

// MARK: - Option
class Option: Object,Codable {
    @Persisted var id: String = "0"
    @Persisted var fieldID: String = ""
    @Persisted var label: String = ""
    @Persisted var labelEn: String = ""

    @Persisted var value: String
    @Persisted var optionImg: String?
    @Persisted var hasChild: String
    @Persisted var parentID: String?
    @Persisted var order: String
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
