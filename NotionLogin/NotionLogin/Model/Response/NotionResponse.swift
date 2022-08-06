//
//  NotionResponse.swift
//  NotionLogin
//
//  Created by una on 2021/12/28.
//

import Foundation

public protocol NotionResponse {

    associatedtype Item

    var object: NotionObject { get set }

    var next_cursor: String? { get set }

    var has_more: Bool? { get set }

    var results: [Item] { get set }

}

public struct NotionDataBaseResponse: NotionResponse, Equatable, Codable {

    public typealias Item = NotionDataBase

    public var object: NotionObject

    public var next_cursor: String?

    public var has_more: Bool?

    public var results: [Item] = []
}


public struct NotionPageResponse: NotionResponse, Equatable, Codable  {

    public  typealias Item = NotionPage

    public var object: NotionObject

    public var next_cursor: String?

    public var has_more: Bool?

    public var results: [Item] = []
}

