//
//  BookDataSchema.swift
//  MyNotion
//
//  Created by una on 2021/10/15.
//

import Foundation
import RealmSwift

class RealmWriter: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var lastEditTime = Date()
    
    var series = List<RealmSeries>()
    
    override static func primaryKey() -> String {
        return "id"
    }
}

class RealmSeries: Object {
    @objc dynamic var id = ""
    @objc dynamic var title = ""
    @objc dynamic var tag = ""
    @objc dynamic var type = ""
    @objc dynamic var lastEditTime = Date()
    
    var books = List<RealmBook>()
    var owners = LinkingObjects(fromType: RealmWriter.self, property: "series")
    
    override static func primaryKey() -> String {
        return "id"
    }
    
}

class RealmBook: Object {
    @objc dynamic var id = ""
    @objc dynamic var title = ""
    @objc dynamic var starRating = ""
    @objc dynamic var date: Date?
    @objc dynamic var lastEditTime = Date()
    
    var purchase = List<RealmPurchase>()
    var owners = LinkingObjects(fromType: RealmSeries.self, property: "books")
    
    override static func primaryKey() -> String {
        return "id"
    }
}

class RealmPurchase: Object {
    @objc dynamic var id = ""
    @objc dynamic var title = ""
    @objc dynamic var price: Int64 = 0
    @objc dynamic var realPrice: Int64 = 0
    @objc dynamic var platform = ""
    @objc dynamic var date: Date?
    @objc dynamic var lastEditTime = Date()
    
    var owners = LinkingObjects(fromType: RealmBook.self, property: "purchase")
    
    override static func primaryKey() -> String {
        return "id"
    }
}
