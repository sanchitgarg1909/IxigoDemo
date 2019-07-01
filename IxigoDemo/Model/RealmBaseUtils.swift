//
//  RealmBaseUtils.swift
//  IxigoDemo
//
//  Created by Sanchit Garg on 01/07/19.
//  Copyright © 2019 Sanchit Garg. All rights reserved.
//

import RealmSwift

class RealmBaseUtils {
    
    class func realmConfig() -> Realm.Configuration {
        
        return Realm.Configuration(schemaVersion: 1, migrationBlock: { (migration, oldSchemaVersion) in
            
        }, deleteRealmIfMigrationNeeded: true, shouldCompactOnLaunch: { (totalBytes, usedBytes) -> Bool in
            return true
        })
    }
    
    static var isFirstTime = true
    
    private class func realmInstance() -> Realm {
        do {
            if isFirstTime {
                let realm = try Realm(configuration: realmConfig())
                isFirstTime = false
                realm.invalidate()
            }
            
            let newRealm = try Realm(configuration: realmConfig())
            return newRealm
        } catch {
            if isFirstTime {
                deleteRealmFiles(atURL: Realm.Configuration.defaultConfiguration.fileURL!)
            }
            
            return try! Realm(configuration: realmConfig())
        }
    }
    
    class func write(_ block: @escaping ((Realm) -> Void)) {
        
        autoreleasepool {
            let currentRealm = realmInstance()
            
            if currentRealm.isInWriteTransaction {
                return
            } else {
                try! currentRealm.write {
                    block(currentRealm)
                }
            }
        }
    }
    
    class func update(_ object: Object, block: @escaping (() -> Void)) {
        if object.isInvalidated {
            return
        }
        
        RealmBaseUtils.write { (realmInstance) in
            if object.isInvalidated {
                return
            }
            block()
        }
    }
    
    class func add(_ object: Object, updatesAllowed update: Bool = true) {
        RealmBaseUtils.write { (realmInstance) in
            realmInstance.add(object, update: update)
        }
    }
    
    class func add<S: Sequence>(_ objects: S, updatesAllowed update: Bool = true) where S.Iterator.Element: Object {
        RealmBaseUtils.write { (realmInstance) in
            realmInstance.add(objects, update: update)
        }
    }
    
    class func delete(_ object: Object) {
        RealmBaseUtils.write { (realmInstance) in
            if object.isInvalidated {
                return
            }
            realmInstance.delete(object)
        }
    }
    
    class func delete<S: Sequence>(_ objects: S) where S.Iterator.Element: Object {
        RealmBaseUtils.write { (realmInstance) in
            realmInstance.delete(objects)
        }
    }
    
    class func delete(fromEntity entityClass: Object.Type, withPredicate predicate: NSPredicate? = nil) {
        RealmBaseUtils.delete(RealmBaseUtils.get(fromEntity: entityClass, withPredicate: predicate))
    }
    
    class func delete(fromEntity entityClass: Object.Type, withPrimaryKey primaryKey: String) {
        if let object = RealmBaseUtils.get(fromEntity: entityClass, withPrimaryKey: primaryKey) {
            RealmBaseUtils.delete(object)
        }
    }
    
    class func get<R: Object>(fromEntity entityClass : R.Type, withPredicate predicate: NSPredicate? = nil, sortedByKey sortKey: String? = nil, inAscending isAscending: Bool = true) -> Results<R> {
        var objects = realmInstance().objects(entityClass)
        if predicate != nil {
            objects = objects.filter(predicate!)
        }
        if sortKey != nil {
            objects = objects.sorted(byKeyPath: sortKey!, ascending: isAscending)
        }
        
        return objects
    }
    
    class func getFirst<R: Object>(fromEntity entityClass : R.Type, withPredicate predicate: NSPredicate? = nil, sortedByKey sortKey: String? = nil, inAscending isAscending: Bool = true) -> R? {
        var objects = realmInstance().objects(entityClass) as Results<R>
        if predicate != nil {
            objects = objects.filter(predicate!)
        }
        if sortKey != nil {
            objects = objects.sorted(byKeyPath: sortKey!, ascending: isAscending)
        }
        return objects.first
    }
    
    class func get<R: Object>(fromEntity entityClass : R.Type, withPrimaryKey primaryKey: String) -> R? {
        return realmInstance().object(ofType: entityClass, forPrimaryKey: primaryKey as AnyObject)
    }
    
    class func deleteRealmFiles(atURL realmURL: URL) {
        let realmURLs = [
            realmURL,
            realmURL.appendingPathExtension("lock"),
            realmURL.appendingPathExtension("note"),
            realmURL.appendingPathExtension("management")
        ]
        for path in realmURLs {
            try? FileManager.default.removeItem(at: path)
        }
    }

}
