//
//  Sort.swift
//  MyNotion
//
//  Created by una on 2021/10/14.
//

import Foundation

public enum SortDirection: String, Codable {
    case ascending
    case descending
}


public enum TimeStamp: String, Codable {
    case created_time
    case last_edited_time
}


public struct Sort: Codable {
    let property: String?
    let timestamp: TimeStamp?
    let direction: SortDirection?
}
