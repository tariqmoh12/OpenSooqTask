//
//  CategoriesModel.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 28/12/2023.
//

import Foundation
import RealmSwift

// MARK: - ResultsModelRealm
class ResultsModelRealm: Object, Codable {
    @Persisted @objc dynamic var success: Bool = false
    @Persisted @objc dynamic var result: ResultModelRealm?

    enum CodingKeys: String, CodingKey {
        case success
        case result
    }
}

// MARK: - ResultModelRealm
class ResultModelRealm: Object, Codable {
    @Persisted @objc dynamic var status: Int = 0
    @Persisted @objc dynamic var data: CategoriesModelRealm?

    enum CodingKeys: String, CodingKey {
        case status
        case data
    }
}

// MARK: - CategoriesModelRealm
class CategoriesModelRealm: Object, Codable {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var items = List<CategoryModelRealm>()

    enum CodingKeys: String, CodingKey {
        case items
    }
}


// MARK: - Item
class CategoryModelRealm: Object, Codable {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted @objc  var name: String?
    @Persisted  var order: Int?
    @Persisted  var parent_id: Int?
    @Persisted @objc var label: String?
    @Persisted @objc var label_en: String?
    @Persisted  var has_child: Int?
    @Persisted @objc var reporting_name: String?
    @Persisted @objc var icon: String?
    @Persisted @objc var label_ar: String?
    @Persisted var subCategories = List<CategoryModelRealm>()
    enum CodingKeys: String, CodingKey {
        case id, name, order, parent_id, label, label_en, has_child, reporting_name, icon, label_ar, subCategories
    }
    required convenience init(from decoder: Decoder) throws {
         self.init()
         let container = try decoder.container(keyedBy: CodingKeys.self)
         id = try container.decode(Int.self, forKey: .id)
         name = try container.decodeIfPresent(String.self, forKey: .name)
         order = try container.decodeIfPresent(Int.self, forKey: .order)
         parent_id = try container.decodeIfPresent(Int.self, forKey: .parent_id)
         label = try container.decodeIfPresent(String.self, forKey: .label)
         label_en = try container.decodeIfPresent(String.self, forKey: .label_en)
         has_child = try container.decodeIfPresent(Int.self, forKey: .has_child)
         reporting_name = try container.decodeIfPresent(String.self, forKey: .reporting_name)
         icon = try container.decodeIfPresent(String.self, forKey: .icon)
         label_ar = try container.decodeIfPresent(String.self, forKey: .label_ar)

         if let subCategories = try container.decodeIfPresent([CategoryModelRealm].self, forKey: .subCategories) {
             self.subCategories.append(objectsIn: subCategories)
         }
     }

}
