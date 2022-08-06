//
//  AuthenticationClient.swift
//  NotionLogin
//
//  Created by una on 2021/12/22.
//

import Foundation
import ComposableArchitecture

public struct LoginRequest {
    public var code: String
}

public struct AuthenticationClient {
    public var login: (LoginRequest) -> Effect<Token, NetworkError>
}

extension AuthenticationClient {
    static let live = AuthenticationClient(
        login: { request in
            return NetworkManger().authToken(code: request.code)
                .eraseToEffect()
    })
}

#if DEBUG
  extension AuthenticationClient {
    public static let failing = Self(
        login: { _ in .failing("AuthenticationClient.login") }
    )
  }
#endif
