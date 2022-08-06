//
//  NotionDatabase.swift
//  NotionLogin
//
//  Created by una on 2021/12/30.
//

import Foundation

public struct NotionDataBase: Codable, Equatable {

    private enum CodingKeys: String, CodingKey {
        case object, id, cover, icon, title, properties, parent, url
        case createdTime = "created_time"
        case lastEditedTime = "last_edited_time"
    }

    public var object: NotionObject

    public var id: String

    public var cover: String?

    public var icon: SimpleObject?

    public var createdTime: String?

    public var lastEditedTime: String?

    public var title: [Title]?

    public var properties: [String: Properties]

    public var parent: SimpleObject?

    public var url: String?

    public lazy var titleString: String = {
        return title?.compactMap{ $0.plainText }
        .first ?? ""
    }()

    public init(
        object: NotionObject,
        id: String
    ) {
        self.object = object
        self.id = id
        self.properties = [:]
    }
}
