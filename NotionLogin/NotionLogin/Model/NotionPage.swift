//
//  NotionPage.swift
//  NotionLogin
//
//  Created by una on 2021/12/30.
//

import Foundation

public struct NotionPage: Codable, Equatable {

    private enum CodingKeys: String, CodingKey {
        case object, id, parent, url, properties
        case createdTime = "created_time"
        case lastEditedTime = "last_edited_time"
    }

    public var object: NotionObject

    public var id: String

    public var createdTime: String?

    public var lastEditedTime: String?

    public var parent: SimpleObject?

    public var properties: [String: Properties]

    public var url: String?

    public lazy var titleString: String = {
        return properties.values
            .compactMap { $0.type.value as? [Title] }
            .first?
            .first?
            .plainText ?? ""
    }()

    public init(object: NotionObject, id: String) {
        self.object = object
        self.id = id
        self.properties = [:]
    }
}
