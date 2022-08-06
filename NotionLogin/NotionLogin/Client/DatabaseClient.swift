//
//  DatabaseClient.swift
//  NotionLogin
//
//  Created by una on 2021/12/30.
//

import Foundation
import ComposableArchitecture

public struct DatabaseReqest: Equatable {
    var id: String
    var startCursor: String?

    public init(id: String, startCursor: String?) {
        self.id = id
        self.startCursor = startCursor
    }
}

public struct DatabaseClient {
    public var items: (DatabaseReqest) -> Effect<NotionPageResponse, NetworkError>
}

extension DatabaseClient {
    static let live = DatabaseClient(
        items: { request in
            return NetworkManger().requestDatabaseItem(databaseId: request.id, startCursor: request.startCursor)
                .eraseToEffect()
        }
    )
}


#if DEBUG
extension DatabaseClient {
    public static let failing = Self(
        items: { _ in .failing("DatabaseClient.items")}
    )
}
#endif
