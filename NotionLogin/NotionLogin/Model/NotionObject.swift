//
//  NotionObject.swift
//  NotionLogin
//
//  Created by una on 2021/12/28.
//

import Foundation

public enum NotionObject: String, Equatable, Codable {
    case database
    case page
    case list
    case error

    static var name: String {
        return "object"
    }
}

public struct SimpleObject: Equatable, Codable {
    public let type: NotionType

    private enum CodingKeys: String, CodingKey {
        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeString = try container.decode(String.self, forKey: .type)

        do {
            self.type = try .init(type: typeString, from: decoder)
        } catch {
            print("SimpleObject - error: [\(typeString)] \(decoder.codingPath)")
            throw error
        }
    }
}

public struct Title: Equatable, Codable {

    private enum CodingKeys: String, CodingKey {
        case type, annotations, href
        case plainText = "plain_text"
    }

    public let type: NotionType
    public let annotations: Annotations?
    public let plainText: String?
    public let href: String?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeString = try container.decode(String.self, forKey: .type)
        do {
            self.type = try .init(type: typeString, from: decoder)
            self.annotations = try? container.decode(Annotations.self, forKey: .annotations)
            self.plainText = try? container.decode(String.self, forKey: .plainText)
            self.href = try? container.decode(String.self, forKey: .href)
        } catch {
            print("Title - error: [\(typeString)] \(decoder.codingPath)")
            throw error
        }
    }
}

public struct Properties: Equatable, Codable {
    public let type: NotionType
    public let id: String
    public let name: String?

    private enum CodingKeys: String, CodingKey {
        case type, id, name
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeString = try container.decode(String.self, forKey: .type)
        do {
            self.type = try .init(type: typeString, from: decoder)
            self.id = try container.decode(String.self, forKey: .id)
            self.name = try? container.decode(String.self, forKey: .name)
        } catch {
            print("Properties - error: [\(typeString)] \(decoder.codingPath)")
            throw error
        }
    }
}

public enum NotionType: Equatable, Codable {
    
    case rollup(Rollup?)
    case relation([Relation]?)
    case formula(Formula?)
    case number(Number?)
    case lastEditedTime(String?)
    case createTime(String?)
    case select([Option]?)
    case date(NotionDate?)
    case files(File?)
    case text(NotionText?)
    case checkbox
    case multiSelect([Option]?)
    case emoji(String?)
    case pageId(String?)
    case databaseId(String?)
    case richText(RichText?)
    case title([Title]?)
    case url


    private enum CodingKeys: String, CodingKey {
        case emoji, text, relation, rollup, formula, number, select, date, files, title, checkbox, url
        case pageId = "page_id"
        case lastEditedTime = "last_edited_time"
        case createTime = "create_time"
        case multiSelect = "multi_select"
        case richText = "rich_text"
        case databaseId = "database_id"
    }

    public init(type: String, from decoder: Decoder) throws {
        guard let keyType = CodingKeys(rawValue: type) else {
            print("type error =\(type)")
            throw DecodingError.typeMismatch(
                NotionType.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Wrong type for NotionType(\(type)"
                )
            )
        }

        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch keyType {
        case .emoji:
            let emoji = try? container.decode(String.self, forKey: .emoji)
            self = .emoji(emoji)
            return

        case .text:
            let text = try? container.decode(NotionText.self, forKey: .text)
            self = .text(text)
            return

        case .pageId:
            let pageId = try? container.decode(String.self, forKey: .pageId)
            self = .pageId(pageId)
            return

        case .databaseId:
            let databaseId = try? container.decode(String.self, forKey: .databaseId)
            self = .databaseId(databaseId)
            return


        case .rollup:
            let rollup = try? container.decode(Rollup.self, forKey: .rollup)
            self = .rollup(rollup)
            return

        case .formula:
            let formula = try? container.decode(Formula.self, forKey: .formula)
            self = .formula(formula)
            return

        case .number:
            let number = try? container.decode(Number.self, forKey: .number)
            self = .number(number)
            return

        case .lastEditedTime:
            let lastEditedTime = try? container.decode(String.self, forKey: .lastEditedTime)
            self = .lastEditedTime(lastEditedTime)
            return

        case .createTime:
            let createTime = try? container.decode(String.self, forKey: .createTime)
            self = .createTime(createTime)
            return

        case .select:
            let select = try? container.decode([Option].self, forKey: .select)
            self = .select(select)
            return

        case .date:
            let date = try? container.decode(NotionDate.self, forKey: .date)
            self = .date(date)
            return

        case .files:
            let files = try? container.decode(File.self, forKey: .files)
            self = .files(files)
            return

        case .multiSelect:
            let multiSelect = try? container.decode([Option].self, forKey: .multiSelect)
            self = .multiSelect(multiSelect)
            return

        case .richText:
            let richText = try? container.decode(RichText.self, forKey: .richText)
            self = .richText(richText)
            return

        case .title:
            if let title = try? container.decode([Title].self, forKey: .title) {
                self = .title(title)
            } else if let title = try? container.decode(Title.self, forKey: .title) {
                self = .title([title])
            } else {
                self = .title(nil)
            }

            return

        case .relation:
            if let relation = try? container.decode([Relation].self, forKey: .relation) {
                self = .relation(relation)
            } else if let relation = try? container.decode(Relation.self, forKey: .relation) {
                self = .relation([relation])
            } else {
                self = .relation(nil)
            }
            return

        case .checkbox:
            self = .checkbox
            return

        case .url:
            self = .url
            return

        }

    }

    var value: Any? {
        switch self {
        case let .emoji(value):
           return value

        case let .text(value):
            return value

        case let .pageId(value):
            return value

        case let .databaseId(value):
            return value

        case let .relation(value):
            return value

        case let .rollup(value):
            return value

        case let .formula(value):
            return value

        case let .number(value):
            return value

        case let .lastEditedTime(value):
            return value

        case let .createTime(value):
            return value

        case let .select(value):
            return value

        case let .date(value):
            return value

        case let .files(value):
            return value

        case let .multiSelect(value):
            return value

        case let .richText(value):
            return value

        case let .title(value):
            return value

        case .checkbox:
            return nil

        case .url:
            return nil

        }
    }
}


public struct NotionText: Equatable, Codable {
    public let content: String
    public let link: String?
}

public struct Annotations: Equatable, Codable {
    public let bold: Bool
    public let italic: Bool
    public let strikethrough: Bool
    public let underline: Bool
    public let code: Bool
    public var color: String
}


public struct Rollup: Equatable, Codable {
    public let rollup_property_name: String?
    public let relation_prpperty_name: String?
    public let rollup_property_id: String?
    public let relation_property_id: String?
    public let function: Function?
}

public enum Function: String, Equatable, Codable {
    case earlist_date
    case latest_date
}

public struct Relation: Equatable, Codable {
    public let id: String
    public let database_id: String?
    public let synced_property_name: String?
    public let synced_property_id: String?
}

public struct Formula: Equatable, Codable {
    public let expression: String?
}

public struct Option: Equatable, Codable {
    public var id: String
    public var name: String
    public var color: String
}

public struct Number: Equatable, Codable {
    public var format: String
}


public struct File: Equatable, Codable {
    public let url: String?
    public let expiry_time: String?
}

public struct RichText: Equatable, Codable {
}

public struct NotionDate: Equatable, Codable {

    private enum CodingKeys: String, CodingKey {
        case start, end
        case timeZone = "time_zone"
    }

    public let start: String?
    public let end: String?
    public let timeZone: String?
}
