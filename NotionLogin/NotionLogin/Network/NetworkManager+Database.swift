//
//  NetworkManager+Database.swift
//  NotionLogin
//
//  Created by una on 2021/12/30.
//

import Foundation
import Combine

extension NetworkManger {

    func requestDatabaseItem(databaseId: String, startCursor: String?) -> AnyPublisher<NotionPageResponse, NetworkError> {
        return request(
            .queryDatabase(
                databaseId: databaseId,
                filter: nil,
                sorts: nil,
                startCursor: startCursor,
                pageSize: nil
            )
        )
            .tryMap { data -> NotionPageResponse in
//                                if let log = String(data: data, encoding: .utf8) {
//                                    print("response: \(log)")
//                                }

                guard let response = try? JSONDecoder().decode(NotionPageResponse.self, from: data) else {
                    throw NetworkError.parsing
                }
                return response
            }
            .mapError{ ($0 as? NetworkError) ?? NetworkError.unknown }
            .eraseToAnyPublisher()
    }
}
