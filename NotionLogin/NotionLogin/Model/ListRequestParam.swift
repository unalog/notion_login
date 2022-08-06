//
//  ListRequestParam.swift
//  MyNotion
//
//  Created by una on 2021/10/14.
//

import Foundation

struct ListRequestParam: Codable {
    var page_size: Int = 50
    let start_cursor: String?
    var sorts = [Sort(property: nil, timestamp: TimeStamp.last_edited_time.rawValue, direction: SortDirection.descending.rawValue)]
    init(start_cursor: String?) {
        self.start_cursor = start_cursor
    }
    
    func toJsonData() -> Data? {
        if let jsonData = try? JSONEncoder().encode(self), let jsonString = String(data: jsonData, encoding: .utf8) {
            let str = jsonString.replacingOccurrences(of: "\\/", with: "/")
            
            print(str)
            if let data = str.data(using: .utf8) {
                return data
            }
        }
        return nil
    }
}
