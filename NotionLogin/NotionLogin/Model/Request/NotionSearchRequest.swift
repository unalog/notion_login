//
//  NotionSearchRequest.swift
//  NotionLogin
//
//  Created by una on 2021/12/28.
//

import Foundation

struct NotionSearchRequest: Codable {
    var filter: Filter?
    var sort: Sort?
    var query: String?

    public init(filter: Filter?, sort: Sort?, query: String?) {
        self.filter = filter
        self.sort = sort
        self.query = query
    }
}
