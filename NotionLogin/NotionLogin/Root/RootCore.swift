//
//  RootCore.swift
//  NotionLogin
//
//  Created by una on 2021/12/28.
//

import Foundation
import ComposableArchitecture

extension NotionDataBase: Identifiable {}

public struct RootState: Equatable {
    var login: LoginState?

    var isLoginPresented: Bool
    var isActiveDatabaseList: Bool = false

    var databases: IdentifiedArrayOf<NotionDataBase> = []
    var selection: Identified<NotionDataBase.ID, DatabaseDetailState>?
}

public enum RootAction {

    case login(LoginAction)
    case databaseDetail(DatabaseDetailAction)

    case database(id: NotionDataBase.ID, action: DatabaseAction)

    case setSeet(isPresented: Bool)

    case setNavigation(selection: String?)

    case searchDatabaseList
    case searchDatabaseResponse(Result<[NotionDataBase], NetworkError>)

    case onAppear
}

public struct RootEnvironment {
    public var searchClient: SearchClient
    public var mainQueue: AnySchedulerOf<DispatchQueue>
}

let rootReducer = Reducer<RootState, RootAction, RootEnvironment>.combine(
    databaseDetailReducer
        .pullback(
            state: \Identified.value,
            action: .self,
            environment: { $0 }
        )
        .optional()
        .pullback(
            state: \RootState.selection,
            action: /RootAction.databaseDetail,
            environment: { _ in DatabaseDetailEnvironment(
                databaseClient: DatabaseClient.live,
                mainQueue: .main
            )
            }
        ),
    loginReducer
        .optional()
        .pullback(state: \.login,
                  action: /RootAction.login,
                  environment: { .init(
                    authenticationClient: AuthenticationClient.live,
                    mainQueue: $0.mainQueue
                  )
            }
        ),
    Reducer { state, action, environment in
        struct CancelId: Hashable {}
        switch action {
        case .onAppear:
            return Effect(value: .searchDatabaseList)

        case .login:
            return .none
        case .databaseDetail:
            return .none
        case .setSeet(isPresented: true):
            state.isLoginPresented = true
            state.login = LoginState()
            return .none

        case .setSeet(isPresented: false):
            state.isLoginPresented = false
            if let _ = state.login?.token {
                state.login = nil
                return Effect(value: .searchDatabaseList)
            }

            state.login = nil
            return .cancel(id: CancelId())

        case let .setNavigation(selection: .some(navigatedId)):
            guard let database = state.databases[id: navigatedId] else { return .none }
            state.selection = Identified(
                DatabaseDetailState(database: database),
                id: navigatedId
            )
            return .none
        case .setNavigation(selection: .none):
            state.selection = nil
            return .cancel(id: CancelId())

        case .searchDatabaseList:
            return environment.searchClient
                .databases(SearchRequest(keyword: nil))
                .receive(on: environment.mainQueue)
                .catchToEffect(RootAction.searchDatabaseResponse)

        case let .searchDatabaseResponse(.failure(error)):
            print(error.localizedDescription)
            return .none

        case let .searchDatabaseResponse(.success(response)):
            print("complete")
            state.databases.removeAll()
            response.forEach { database in
                state.databases.append(database)
            }
            return .none
        }
    }
)
