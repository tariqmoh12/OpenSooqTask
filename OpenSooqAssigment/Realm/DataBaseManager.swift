//
//  DataBaseManager.swift
//  ShahidAssigment
//
//  Created by Tariq on 06/01/2023.
//

import Foundation
import RealmSwift
import Realm

// MARK: - CustomResult
enum CustomResult<T> {
    case success(T)
    case failure(Error)
}

// MARK: - RealmManager
final class RealmManager {
    static let shared = RealmManager()

    private let realm: Realm

    private init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }

    func saveObject<T: Object>(_ object: T, completion: @escaping (CustomResult<Void>) -> Void) {
        do {
            if realm.object(ofType: T.self, forPrimaryKey: object.value(forKey: "id")) == nil {
                try realm.write {
                    realm.add(object)
                    completion(.success(()))
                }
            } else {
                let error = NSError(domain: "YourAppDomain", code: 2, userInfo: [NSLocalizedDescriptionKey: "Object already exists in favorites"])
                completion(.failure(error))
            }
        } catch {
            print("Error saving object to Realm: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }

    func deleteObject<T: Object>(_ object: T, completion: @escaping (CustomResult<Void>) -> Void) {
        do {
            if let existingObject = realm.object(ofType: T.self, forPrimaryKey: object.value(forKey: "id")) {
                try realm.write {
                    realm.delete(existingObject)
                    completion(.success(()))
                }
            } else {
                let error = NSError(domain: "YourAppDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Object not found in favorites"])
                completion(.failure(error))
            }
        } catch {
            print("Error deleting object from Realm: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }

    func getObjects<T: Object>(_ objectType: T.Type) -> Results<T> {
        return realm.objects(objectType)
    }

    func removeAllObjectsOfType<T: Object>(_ objectType: T.Type) {
        do {
            try realm.write {
                realm.delete(realm.objects(objectType))
            }
        } catch {
            print("Error removing all objects of type from Realm: \(error.localizedDescription)")
        }
    }
}
