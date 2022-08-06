//
//  Series.swift
//  MyNotion
//
//  Created by una on 2021/06/24.
//

import Foundation
import SwiftyJSON

struct Series {
    var id: String
    var title : String
    var imageURL: String
    var booksids: [String]
    var writerIds: [String]
    var tag: String
    var type: String
    var writer: [Writer]?
    var book: [Book]?
    var lastEditedTime: Date
    
    init?(jsonData: JSON) {
        
        self.id = jsonData["id"].string ?? ""
        
        guard let propertiesJson = jsonData["properties"].dictionary else { return nil }
        
        let titleProperties = Properties(jsonData: propertiesJson["title"])
        self.title = titleProperties?.data.string ?? ""
        
        let tagProperties = Properties(jsonData: propertiesJson["tag"])
        self.tag = tagProperties?.data.string ?? ""
        
        let typeProperties = Properties(jsonData: propertiesJson["type"])
        self.type = typeProperties?.data.string ?? ""
        
        let writerProperties = Properties(jsonData: propertiesJson["writer"])
        self.writerIds = writerProperties?.data.strings ?? []
        
        let coverProperties = Properties(jsonData: propertiesJson["cover"])
        self.imageURL = coverProperties?.data.strings.first ?? ""
        
        let bookProperties = Properties(jsonData: propertiesJson["book"])
        self.booksids = bookProperties?.data.strings ?? []
        
        let lastEditTimeProperties = Properties(jsonData: propertiesJson["last edited time"])
        self.lastEditedTime = lastEditTimeProperties?.data.dateValue ?? Date()
    }
   
    init?(realm: RealmSeries, writer: RealmWriter? = nil, book: RealmBook? = nil) {
        self.id = realm.id
        self.title = realm.title
        self.tag = realm.tag
        self.type = realm.type
        self.imageURL = ""
        self.lastEditedTime = realm.lastEditTime
        self.booksids = []
        if writer == nil {
            self.writer = realm.owners.compactMap{ Writer(realm: $0, series: realm)}
        }
        
        if book == nil {
            self.book = realm.books.compactMap{ Book(realm: $0, series: realm)}.sorted{ $0.title < $1.title }
        }
        self.writerIds = []
        
    }
}

extension Series {
    var editData: Date {
        return book?.sorted{ $0.editData > $1.editData }.first?.editData ?? Date(timeIntervalSince1970: 0)
    }
}
