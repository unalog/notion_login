//
//  LoginCore.swift
//  NotionLogin
//
//  Created by una on 2021/12/22.
//

import Foundation
import ComposableArchitecture

public struct LoginState: Equatable {
    public var code: String?
    public var token: Token?
    public var isDismiss: Bool?

    public init() {}
}

public enum LoginAction: Equatable {
    case loginResponse(Result<Token, NetworkError>)
    case requestLogin(String?)
    case dismissLogin
}

public struct LoginEnvironment {
    public var authenticationClient: AuthenticationClient
    public var mainQueue: AnySchedulerOf<DispatchQueue>
    
    public init(
        authenticationClient: AuthenticationClient,
        mainQueue: AnySchedulerOf<DispatchQueue>
    ) {
        self.authenticationClient = authenticationClient
        self.mainQueue = mainQueue
    }
}

public let loginReducer = Reducer<LoginState, LoginAction, LoginEnvironment> { state, action, environment in
    struct CancelId: Hashable {}

    switch action {
    case .loginResponse(.failure):
        state.token = nil
        return Effect(value: .dismissLogin)
            .eraseToEffect()
            .cancellable(id: CancelId())

    case let .loginResponse(.success(response)):
        UserDataKey.token.save(response.accessToken)
        UserDataKey.workspaceId.save(response.workspaceId)
        UserDataKey.botId.save(response.botId)
        state.token = response
        return Effect(value: .dismissLogin)
            .eraseToEffect()
            .cancellable(id: CancelId())

    case let .requestLogin(code):
        state.code = code
        guard let code = code else { return .none}

        return environment.authenticationClient
            .login(LoginRequest(code: code))
            .receive(on: environment.mainQueue)
            .catchToEffect(LoginAction.loginResponse)

    case .dismissLogin:
        state.isDismiss = true
        return .none
    }
}
