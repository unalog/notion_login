//
//  DatabaseDetailView.swift
//  NotionLogin
//
//  Created by una on 2021/12/30.
//

import SwiftUI
import ComposableArchitecture

extension NotionPage: Identifiable {}

public struct DatabaseDetailState: Equatable {
    public var database: NotionDataBase
    public var items: IdentifiedArrayOf<NotionPage> = []
    public var nextCursor: String?

    public init(database: NotionDataBase) {
        self.database = database
    }
}

public enum DatabaseDetailAction {
    case onAppear
    case requestItems(cursor: String?)

    case itemsResponse(Result<NotionPageResponse, NetworkError>)
}

public struct DatabaseDetailEnvironment {
    var databaseClient: DatabaseClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let databaseDetailReducer = Reducer<DatabaseDetailState, DatabaseDetailAction, DatabaseDetailEnvironment>.init {
    state, action, environment in

    struct CancelId: Hashable {}

    switch action {
    case .onAppear:
        return Effect(value: .requestItems(cursor: nil))
    case let .requestItems(cursor):
        if cursor == nil {
            state.items.removeAll()
        }

        return environment.databaseClient
            .items(DatabaseReqest(id: state.database.id, startCursor: cursor))
            .receive(on: environment.mainQueue)
            .catchToEffect(DatabaseDetailAction.itemsResponse)

    case let .itemsResponse(.failure(error)):
        print(error.localizedDescription)
        return .none

    case let .itemsResponse(.success(response)):
        print("success")
        state.nextCursor = response.next_cursor
        response.results.forEach { page in
            state.items.append(page)
        }
        return .cancel(id: CancelId())
    }
}

struct DatabaseDetailView: View {
    let store: Store<DatabaseDetailState, DatabaseDetailAction>
    let check = MemoryCheck(name: "DatabaseDetailView")

    init (store: Store<DatabaseDetailState, DatabaseDetailAction>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(self.store) { viewStore in
            var database = viewStore.database
            Text(database.titleString)

            ScrollView{
                ForEach(viewStore.items) { item in
                    var page = item
                    Text(page.titleString)
                }
            }
            .onAppear { viewStore.send(.onAppear) }
        }
    }
}

class MemoryCheck {
    let name: String

    init(name: String) {
        self.name = name
    }

    deinit {
        print ("deinit[\(name)]")
    }
}

struct DatabaseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DatabaseDetailView(
            store: .init(
            initialState: DatabaseDetailState(
                database: NotionDataBase(object: .database, id: "123456")
            ),
            reducer: databaseDetailReducer,
            environment: DatabaseDetailEnvironment(
                databaseClient: DatabaseClient.live,
                mainQueue: .main
            )
            )
        )
    }
}
