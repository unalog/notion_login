//
//  NotionLoginApp.swift
//  NotionLogin
//
//  Created by una on 2021/12/20.
//

import ComposableArchitecture
import SwiftUI

@main
struct NotionLoginApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: .init(
                    initialState: RootState(
                        isLoginPresented: UserDataKey.token.value == nil
                    ),
                    reducer: rootReducer,
                    environment: RootEnvironment(
                        searchClient: SearchClient.live,
                        mainQueue: .main
                    )
                )
            )
        }
    }
}
