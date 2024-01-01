//
//  CategoriesModel.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 28/12/2023.
//

import Foundation

// MARK: - CategoriesModel
struct ResultsModel: Codable {
    let success: Bool
    let result: ResultModel
}

// MARK: - Result
struct ResultModel: Codable {
    let status: Int
    let data: CategoriesModel
    let hash: String
}

// MARK: - DataClass
struct CategoriesModel: Codable {
    let items: [CategoryModel]
}

// MARK: - Item
struct CategoryModel: Codable, Hashable {
    let id: Int
    let name: String
    let order, parentID: Int
    let label, labelEn: String
    let hasChild: Int
    let reportingName: String
    let icon: String
    let labelAr: String
    let subCategories: [CategoryModel]?

    enum CodingKeys: String, CodingKey {
        case id, name, order
        case parentID = "parent_id"
        case label
        case labelEn = "label_en"
        case hasChild = "has_child"
        case reportingName = "reporting_name"
        case icon
        case labelAr = "label_ar"
        case subCategories
    }
}
