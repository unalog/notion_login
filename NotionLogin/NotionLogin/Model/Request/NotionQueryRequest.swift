//
//  NotionQueryRequest.swift
//  NotionLogin
//
//  Created by una on 2021/12/30.
//

import Foundation

public struct NotionQueryRequest: Codable {

    enum CodingKeys: String, CodingKey {
        case filter, sorts
        case startCursor = "start_cursor"
        case pageSize = "page_size"
    }

    var filter: Filter?
    var sorts: [Sort]?
    var startCursor: String?
    var pageSize: Int32?

    public init(filter: Filter?, sorts: [Sort]?, startCursor: String?, pageSize: Int32?) {
        self.filter = filter
        self.sorts = sorts
        self.startCursor = startCursor
        self.pageSize = pageSize
    }
}
