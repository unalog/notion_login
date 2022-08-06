//
//  Authoriztion.swift
//  NotionLogin
//
//  Created by una on 2021/12/21.
//

import ComposableArchitecture
import Foundation
import Combine

extension NetworkManger {

    func authToken(code: String) -> AnyPublisher<Token, NetworkError> {
        return request(.oauthToken(code: code))
            .tryMap { data -> Token in
                guard let token = try? JSONDecoder().decode(Token.self, from: data) else {
                    throw NetworkError.parsing
                }


                return token
            }
            .mapError{ ($0 as? NetworkError) ?? NetworkError.unknown }
            .eraseToAnyPublisher()
    }
}
