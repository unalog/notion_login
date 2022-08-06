//
//  Cursor.swift
//  MyNotion
//
//  Created by una on 2021/10/14.
//

import Foundation
import SwiftyJSON

struct Cursor {
    let nextCursor: String
    let hasMore: Bool
    
    init(jsonData: JSON) {
        nextCursor = jsonData["next_cursor"].string ?? ""
        hasMore = jsonData["has_more"].bool ?? false
    }
}
