//
//  Book.swift
//  MyNotion
//
//  Created by una on 2021/06/24.
//
import Foundation
import SwiftyJSON

struct Book {
    var id: String
    var title : String
    var imageURL: String
    var epub: [String]
    var date: Date?
    var starRating: String
    var seriesids: [String]
    var series: [Series]?
    var purchaseIds: [String]
    var purchase: [Purchase]?
    var lastEditedTime: Date
    
    init?(jsonData: JSON) {
        
        self.id = jsonData["id"].string ?? ""
        
        guard let propertiesJson = jsonData["properties"].dictionary else { return nil }
        
        let titleProperties = Properties(jsonData: propertiesJson["title"])
        self.title = titleProperties?.data.string ?? ""
        
        let starRatingProperties = Properties(jsonData: propertiesJson["star rating"])
        self.starRating = starRatingProperties?.data.string ?? ""
        
        let completeProperties = Properties(jsonData: propertiesJson["complete reading date"])
        self.date = completeProperties?.data.dateValue
        
        let coverProperties = Properties(jsonData: propertiesJson["cover"])
        self.imageURL = coverProperties?.data.strings.first ?? ""
        
        let seriesProperties = Properties(jsonData: propertiesJson["series"])
        self.seriesids = seriesProperties?.data.strings ?? []
        
        let epubProperties = Properties(jsonData: propertiesJson["epub"])
        self.epub = epubProperties?.data.strings ?? []
        
        let purchaseProperties = Properties(jsonData: propertiesJson["purchase"])
        self.purchaseIds = purchaseProperties?.data.strings ?? []
        
        let lastEditTimeProperties = Properties(jsonData: propertiesJson["last edited time"])
        self.lastEditedTime = lastEditTimeProperties?.data.dateValue ?? Date()
    }
    
    init?(realm: RealmBook, series: RealmSeries? = nil, purcashe: RealmPurchase? = nil) {
        self.id = realm.id
        self.title = realm.title
        self.imageURL = ""
        self.seriesids = []
        self.date = realm.date
        self.starRating = realm.starRating
        self.lastEditedTime = realm.lastEditTime
        
        if series == nil {
            self.series = realm.owners.compactMap{ Series(realm: $0, book: realm)}
        }
        
        if purchase == nil {
            self.purchase = realm.purchase.compactMap{ Purchase(realm: $0, book: realm)}
        }
        self.epub = []
        purchaseIds = []
    }
}

extension Book {
    var editData: Date {
        if let date = date {
            return date
        }
        
        return purchase?.sorted{ $0.editData > $1.editData }.first?.date ?? Date(timeIntervalSince1970: 0)
    }
}
