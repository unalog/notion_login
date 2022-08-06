//
//  ContentView.swift
//  NotionLogin
//
//  Created by una on 2021/12/20.
//
import ComposableArchitecture
import SwiftUI

struct ContentView: View {

    let store: Store<RootState, RootAction>

    init (store: Store<RootState, RootAction>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                ForEach(viewStore.databases) { database in
                    NavigationLink(
                        destination: IfLetStore(
                            self.store.scope(
                                state: \.selection?.value,
                                action: RootAction.databaseDetail
                            ),
                            then: DatabaseDetailView.init(store:)
                        ),
                        tag: database.id,
                        selection: viewStore.binding(
                            get: \.selection?.id,
                            send: RootAction.setNavigation(selection:)
                        )
                    ) {
                        VStack{
                            DatabaseView(store: .init(initialState: database,
                                                      reducer: databaseReducer,
                                                      environment: DatabaseEnvironment()))
                            Spacer()
                        }
                    }
                }
                .sheet(
                    isPresented: viewStore.binding(
                        get: \.isLoginPresented,
                        send: RootAction.setSeet(isPresented:))
                ) {
                    IfLetStore(
                        self.store.scope(
                            state: \.login,
                            action: RootAction.login
                        ),
                        then: LoginView.init(store: ),
                        else: ProgressView.init
                    )
                }
                .navigationBarTitle("My Notion")
                .navigationBarItems(
                    trailing: HStack(spacing: 20) {
                        Button("Login") {
                            viewStore.send(RootAction.setSeet(isPresented: true))
                        }
                        Button("Database List") {
                            viewStore.send(RootAction.searchDatabaseList)

                        }
                    }
                )
                .onAppear { viewStore.send(.onAppear) }
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: .init(
                initialState: RootState(isLoginPresented: false),
                reducer: rootReducer,
                environment: RootEnvironment(
                    searchClient: SearchClient.live,
                    mainQueue: .main
                )
            )
        )
    }
}
