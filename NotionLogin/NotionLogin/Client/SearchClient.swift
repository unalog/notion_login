//
//  SearchClient.swift
//  NotionLogin
//
//  Created by una on 2021/12/28.
//

import Foundation
import ComposableArchitecture

public struct SearchRequest: Equatable {
    var keyword: String?
    public init(keyword: String?) {
        self.keyword = keyword
    }
}

public struct SearchClient {
    public var databases: (SearchRequest) -> Effect<[NotionDataBase], NetworkError>
    public var pages: (SearchRequest) -> Effect<[NotionPage], NetworkError>
}

extension SearchClient {
    static let live = SearchClient(
        databases: { request in
            return NetworkManger().searchDatabase(keyword: request.keyword)
                .eraseToEffect()
        },
        pages: { request in
            return NetworkManger().searchPage(keyword: request.keyword)
                .eraseToEffect()
        }
    )
}


#if DEBUG
  extension SearchClient {
    public static let failing = Self(
        databases: { _ in .failing("SearchClient.databases") },
        pages: { _ in .failing("SearchClient.pages")}
    )
  }
#endif
