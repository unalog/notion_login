//
//  NetworkManager+Search.swift
//  NotionLogin
//
//  Created by una on 2021/12/28.
//

import Foundation
import Combine

extension NetworkManger {

    func searchDatabase(keyword: String?) -> AnyPublisher<[NotionDataBase], NetworkError> {
        return request(
            .search(
                keyword: keyword,
                filter: Filter(
                    value: NotionObject.database.rawValue,
                    property: NotionObject.name
                )
            )
        )
            .tryMap { data -> [NotionDataBase] in

                do {
                    let response = try JSONDecoder().decode(NotionDataBaseResponse.self, from: data)
                    return response.results
                } catch {
                    print(error.localizedDescription)
                    throw NetworkError.parsing
                }
            }
            .mapError{ ($0 as? NetworkError) ?? NetworkError.unknown }
            .eraseToAnyPublisher()
    }

    func searchPage(keyword: String?) -> AnyPublisher<[NotionPage], NetworkError> {
        return request(
            .search(
                keyword: keyword,
                filter: Filter(
                    value: NotionObject.page.rawValue,
                    property: NotionObject.name
                )
            )
        )
            .tryMap { data -> [NotionPage] in
                guard let response = try? JSONDecoder().decode(NotionPageResponse.self, from: data) else {
                    throw NetworkError.parsing
                }
                return response.results
            }
            .mapError{ ($0 as? NetworkError) ?? NetworkError.unknown }
            .eraseToAnyPublisher()
    }
}
