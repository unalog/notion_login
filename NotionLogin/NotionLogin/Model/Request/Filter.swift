//
//  Filter.swift
//  NotionLogin
//
//  Created by una on 2021/12/28.
//

import Foundation

public struct Filter: Equatable, Codable {

    public var value: String
    public var property: String = "object"
}
