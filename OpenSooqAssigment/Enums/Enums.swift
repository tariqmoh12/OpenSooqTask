//
//  Enums.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 29/12/2023.
//

import Foundation

// MARK: - SectionType
enum SectionType:CaseIterable {
    case list_string_icon
    case list_numeric
    case list_string
    case integer
    case boolean
}

// MARK: - CellInnerItemsType
enum CellInnerItemsType: Int, CaseIterable {
    case icons
    case titles
    case numeric
}
