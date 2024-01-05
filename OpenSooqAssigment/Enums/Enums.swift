//
//  Enums.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 29/12/2023.
//

import Foundation

enum SectionType:CaseIterable {
    case list_string_icon
    case list_numeric
    case list_string
    case integer
    case boolean
}

enum CellInnerItemsType: Int, CaseIterable {
    case icons
    case titles
    case numeric
}
