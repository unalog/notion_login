//
//  NotionLoginTests.swift
//  NotionLoginTests
//
//  Created by una on 2021/12/24.
//

import ComposableArchitecture
import NotionLogin
import XCTest

class NotionLoginTests: XCTestCase {

    func testFlow_Success_Login() {
        var authenticationClient = AuthenticationClient.failing

        authenticationClient.login = { _ in
            Effect(value: .init(accessToken: "abcd",
                                workspaceId: "efgh",
                                workspaceName: "hijk",
                                workspaceIcon: "lmnop",
                                botId: "qwer" ))
        }

        let scheduler = DispatchQueue.test

        let store = TestStore(
            initialState: LoginState(),
            reducer: loginReducer,
            environment: LoginEnvironment(
                authenticationClient: authenticationClient,
                mainQueue: scheduler.eraseToAnyScheduler()
            )
        )

        store.send(.requestLogin("abcdef")) {
            $0.code = "abcdef"
        }

        scheduler.advance()

        store.receive(
            .loginResponse(
                .success(
                    Token(
                        accessToken: "abcd",
                        workspaceId: "efgh",
                        workspaceName: "hijk",
                        workspaceIcon: "lmnop",
                        botId: "qwer"
                    )
                )
            )
        ) {
            $0.token = Token(
                accessToken: "abcd",
                workspaceId: "efgh",
                workspaceName: "hijk",
                workspaceIcon: "lmnop",
                botId: "qwer"
            )
        }

        store.receive(.dismissLogin) {
            $0.isDismiss = true
        }
    }
}
