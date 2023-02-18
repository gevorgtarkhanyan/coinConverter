//
//  RealmWrapper.swift
//  CoinsConverter
//
//  Created by Armen Gasparyan on 12.01.22.
//

import UIKit
import RealmSwift

class RealmWrapper {

    class var shared: RealmWrapper {
        struct Singleton {
            static let instance = RealmWrapper()
        }
        return Singleton.instance
    }
    
    //MARK: - Add
    func addObjectInRealmDB(_ object: Object) {
        do {
            try Realm().write({
                try Realm().add(object, update: .all)
            })
        } catch {
            debugPrint("Something went wrong!")
        }
    }
    
    func addObjectsInRealmDB<T: Object>(_ objects: [T]?) {
        guard let objects = objects else { return }
        objects.forEach { object in
            do {
                try Realm().write({
                    try Realm().add(object, update: .all)
                })
            } catch {
                debugPrint(error.localizedDescription, "Something went wrong!")
            }
        }
    }
    
    func addObjectInRealmDB(_ object: Object, _ objectType: Object.Type) {
        do {
            try Realm().write({
                let copy = try Realm().create(objectType, value: object, update: .all)
                try Realm().add(copy, update: .all)
            })
        } catch {
            debugPrint("Something went wrong!")
        }
    }

    //MARK: - Get
    func getAllObjectsOfModel<T: Object>(_ objectType: T.Type) -> [T]? {
        do {
            let objects = try Realm().objects(objectType)

            return Array(objects)
        } catch {
            debugPrint(error.localizedDescription, "Something went wrong!")
        }

        return nil
    }
    
    func objectOfKey<T: Object>(forPrimaryKey key: String) -> T? {
        do {
            let object = try Realm().object(ofType: T.self, forPrimaryKey: key)
            return object
        } catch {
            debugPrint(error.localizedDescription)
        }
        return nil
    }
    
    func objectsOfKeys<T: Object>(forPrimaryKeys keys: [String]) -> [T]? {
        var objects = [T]()
        for key in keys {
            guard let fiat: T = objectOfKey(forPrimaryKey: key) else { continue }
            objects.append(fiat)
        }
        return objects.isEmpty ? nil : objects
    }
    
    //MARK: - Delete
    func deleteObjectFromRealmDB(_ object: Object?) {
        guard let object = object else { return }
        do {
            try Realm().write({
                try Realm().delete(object)
            })
        } catch {
            debugPrint("Something went wrong!")
        }
    }
    
    func deleteObjectsFromRealmDB<T: Object>(_ objectType: T.Type) {
        do {
            let realm = try Realm()
            try realm.write({
                realm.delete(realm.objects(objectType))
            })
        } catch {
            debugPrint("Something went wrong!")
        }
    }

    func deleteAllFromDB(complation: () -> Void) {
        do {
            try Realm().write({
                try Realm().deleteAll()
                complation()
            })
        } catch {
            debugPrint("Something went wrong!")
        }
    }
    
    //MARK: - Update
    func updateObjects(completation: () -> Void) {
        do {
            try Realm().write({
                completation()
            })
        } catch {
            debugPrint("Something went wrong!")
        }
    }
    
}
