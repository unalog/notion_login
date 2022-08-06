//
//  Purchase.swift
//  MyNotion
//
//  Created by una on 2021/10/15.
//

import Foundation
import SwiftyJSON

struct Purchase {
    var id: String
    var title : String
    var price: Int64
    var realPrice: Int64
    var platform: String
    var date: Date?
    var books: [Book]?
    var lastEditedTime: Date
    
    init?(jsonData: JSON) {
        
        self.id = jsonData["id"].string ?? ""
        
        guard let propertiesJson = jsonData["properties"].dictionary else { return nil }
        
        let titleProperties = Properties(jsonData: propertiesJson["title"])
        self.title = titleProperties?.data.string ?? ""
        
        let priceProperties = Properties(jsonData: propertiesJson["price"])
        self.price = priceProperties?.data.int64Value ?? 0
        
        let realPriceProperties = Properties(jsonData: propertiesJson["realPrice"])
        self.realPrice = realPriceProperties?.data.int64Value ?? 0
        
        let platformProperties = Properties(jsonData: propertiesJson["platform"])
        self.platform = platformProperties?.data.string ?? ""
        
        let dateProperties = Properties(jsonData: propertiesJson["purchase date"])
        self.date = dateProperties?.data.dateValue
        
        let lastEditTimeProperties = Properties(jsonData: propertiesJson["last edited time"])
        self.lastEditedTime = lastEditTimeProperties?.data.dateValue ?? Date()
    }
    
    init?(realm: RealmPurchase, book: RealmBook? = nil) {
        self.id = realm.id
        self.title = realm.title
        self.price = realm.price
        self.realPrice = realm.realPrice
        self.platform = realm.platform
        self.date = realm.date
        self.lastEditedTime = realm.lastEditTime
       
        if book == nil {
            self.books = realm.owners.compactMap{ Book(realm: $0, purcashe: realm)}
        }
    }
}

extension Purchase {
    var editData: Date {
        return date ?? Date(timeIntervalSince1970: 0)
    }
}
