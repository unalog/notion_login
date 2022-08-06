//
//  BookDataManager+Migration.swift
//  MyNotion
//
//  Created by una on 2021/10/15.
//

import Foundation
import RealmSwift

extension BookDataManager {
    static let realmQueue = DispatchQueue(label: "bookdata.queue.realm")

    static var realmConfiguration = { () -> Realm.Configuration in
        var config = Realm.Configuration()
        config.fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("default.realm")
        config.encryptionKey = nil
        config.schemaVersion = 1
        config.migrationBlock = BookDataManager.getMigrationBlock()
        return config
    }()
    static func getMigrationBlock() -> MigrationBlock {
        var block: (_ migration: Migration, _ oldSchemaVersion: UInt64) -> Void
        block = { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: RealmWriter.className()) { old, new in
                    new?["lastEditTime"] = Date()
                }
                migration.enumerateObjects(ofType: RealmSeries.className()) { old, new in
                    new?["lastEditTime"] = Date()
                }
                migration.enumerateObjects(ofType: RealmBook.className()) { old, new in
                    new?["lastEditTime"] = Date()
                }
                migration.enumerateObjects(ofType: RealmPurchase.className()) { old, new in
                    new?["lastEditTime"] = Date()
                }
            }
        }
        return block
    }
}
