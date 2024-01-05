//
//  URLValidator.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 03/01/2024.
//

import Foundation
class URLValidator {
    static func isFullURL(_ urlString: String) -> Bool {
        if let url = URL(string: urlString) {
            return url.scheme != nil
        }
        return false
    }
}
