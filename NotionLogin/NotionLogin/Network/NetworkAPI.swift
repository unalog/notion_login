//
//  NetworkAPI.swift
//  NotionLogin
//
//  Created by una on 2021/12/21.
//

import Foundation

enum Method: String {
    case get = "GET"
    case post = "POST"
}
enum NetworkAPI {
    case oauthToken(code: String)
    case search(keyword: String?, filter: Filter)
    case queryDatabase(databaseId: String, filter: Filter?, sorts: [Sort]?, startCursor: String?, pageSize: Int32?)
}


extension NetworkAPI {
    var url: String {
        switch self {
        case .oauthToken:
            return "https://api.notion.com/v1/oauth/token"
        case .search:
            return "https://api.notion.com/v1/search"
        case let .queryDatabase(databaseId , _, _, _, _):
            return "https://api.notion.com/v1/databases/\(databaseId)/query"
        }
    }

    var method: Method {
        switch self {
        case .oauthToken:
            return .post
        case .search:
            return .post
        case .queryDatabase:
            return .post
        }
    }

    var params: Encodable {
        switch self {
        case let .oauthToken(code):
            return [
                "grant_type": "authorization_code",
                "code": code,
                "redirect_uri": Constant.redirect_uri
            ]
        case let .search(keyword, filter):
            return NotionSearchRequest(
                filter: filter,
                sort: nil,
                query: keyword
            )
        case let .queryDatabase(_, filter, sorts, startCursor, pageSize):
            return NotionQueryRequest(
                filter: filter,
                sorts: sorts,
                startCursor: startCursor,
                pageSize: pageSize
            )
        }
    }

    var header: [String: String] {
        switch self {
        case .oauthToken:
            if let auth = "\(Constant.clientId):\(Constant.client_secret)".data(using: .utf8)?.base64EncodedString() {
                return ["Authorization": "Basic \(auth)"]
            }

        default:
            break
        }
        return [:]
    }
}

