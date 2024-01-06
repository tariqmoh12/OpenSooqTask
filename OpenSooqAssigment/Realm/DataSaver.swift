//
//  DataSaver.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 06/01/2024.
//

import Foundation
import RealmSwift

// MARK: - DataSaver
class DataSaver {
    static func saveData<T: Object>(_ object: T, fileNum: Int) {
        RealmManager.shared.saveObject(object) { result in
            switch result {
            case .success:
                let condition = fileNum == 2
                if condition {
                    UserDefaults.standard.set(true, forKey: "isAttributesHaveBeenSaved")
                    UserDefaults.standard.synchronize()
                }
            case .failure(let error):
                print("Saving Data Error \(error.localizedDescription)")
            }
        }
    }
}
