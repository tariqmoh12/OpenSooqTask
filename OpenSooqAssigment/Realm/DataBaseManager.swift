//
//  DataBaseManager.swift
//  ShahidAssigment
//
//  Created by Tariq Mohammad on 25/11/2023.
//

import Foundation
import RealmSwift
import Realm
final class RealmManager {
    static let shared = RealmManager()

    private let realm: Realm

    private init() {
        // Initialize Realm
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }

    func saveObject<T: Object>(_ object: T, completion: @escaping (SignleResult<Void>) -> Void) {
        do {
            // Check if the object exists in Realm
            if realm.object(ofType: T.self, forPrimaryKey: object.value(forKey: "id")) == nil {
                try realm.write {
                    // Save the object to Realm
                    realm.add(object)
                    completion(.success(()))
                }
            } else {
                // Object already exists in Realm
                completion(.failure(NSError(domain: "YourAppDomain", code: 2, userInfo: [NSLocalizedDescriptionKey: "Object already exists in favorites"])))
            }
        } catch {
            print("Error saving object to Realm: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }

    func deleteObject<T: Object>(_ object: T, completion: @escaping (SignleResult<Void>) -> Void) {
        do {
            // Check if the object exists in Realm
            if let existingObject = realm.object(ofType: T.self, forPrimaryKey: object.value(forKey: "id")) {
                try realm.write {
                    // Delete the object from Realm
                    realm.delete(existingObject)
                    completion(.success(()))
                }
            } else {
                // Object not found in Realm
                completion(.failure(NSError(domain: "YourAppDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Object not found in favorites"])))
            }
        } catch {
            print("Error deleting object from Realm: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    // Get all objects of a specific type
      func getObjects<T: Object>(_ objectType: T.Type) -> Results<T> {
          return realm.objects(objectType)
      }
    
    func removeAllObjectsOfType<T: Object>(_ objectType: T.Type) {
        let realm = try! Realm()

        // Perform a write transaction to delete all objects of the specified type
        try! realm.write {
            realm.delete(realm.objects(objectType))
        }
    }
    
    
}
