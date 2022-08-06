//
//  LoginView.swift
//  NotionLogin
//
//  Created by una on 2021/12/20.
//

import ComposableArchitecture
import SwiftUI
import Combine


struct LoginView: View {

    let store: Store<LoginState, LoginAction>

    init (store: Store<LoginState, LoginAction>) {
        self.store = store
    }

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        WithViewStore(self.store){ viewStore in
            VStack {
                Button("Close") {
                    viewStore.send(LoginAction.dismissLogin)
                }

                LoginWebView(
                    code: viewStore.binding( get: \.code, send: LoginAction.requestLogin)
                )
            }
            .onChange(of: viewStore.isDismiss, perform: { dismiss in
                if dismiss == true {
                    self.presentationMode.wrappedValue.dismiss()
                }
            })

        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            store: .init(
                initialState: LoginState(),
                reducer: loginReducer,
                environment: LoginEnvironment(
                    authenticationClient: AuthenticationClient.live,
                    mainQueue: .main
                )
            )
        )
    }
}
