//
//  Writer.swift
//  MyNotion
//
//  Created by una on 2021/10/15.
//

import Foundation
import SwiftyJSON

struct Writer {
    var id: String
    var name : String
    var seriesIds: [String]
    var series: [Series]?
    var lastEditedTime: Date
    
    init?(jsonData: JSON) {
        self.id = jsonData["id"].string ?? ""
        
        guard let propertiesJson = jsonData["properties"].dictionary else { return nil }
        
        let nameProperties = Properties(jsonData: propertiesJson["name"])
        self.name = nameProperties?.data.string ?? ""
        
        let seriesProperties = Properties(jsonData: propertiesJson["series"])
        self.seriesIds = seriesProperties?.data.strings ?? []
        
        let lastEditTimeProperties = Properties(jsonData: propertiesJson["last edited time"])
        self.lastEditedTime = lastEditTimeProperties?.data.dateValue ?? Date()
    }
    
    init?(realm: RealmWriter, series: RealmSeries? = nil) {
        self.id = realm.id
        self.name = realm.name
        self.lastEditedTime = realm.lastEditTime
        if series == nil {
            self.series = realm.series.compactMap{ Series(realm: $0, writer: realm)}
        }
        
        self.seriesIds = []
    }
}
