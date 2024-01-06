//
//  Structs.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 01/01/2024.
//

import Foundation
import RealmSwift

// MARK: - Item
struct Item {
    let section: Int
    let sectionName: String
}

// MARK: - FullModel
struct FullModel {
    let title: String
    let options : List<Option>?
}
