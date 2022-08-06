//
//  DatabaseView.swift
//  NotionLogin
//
//  Created by una on 2021/12/29.
//

import SwiftUI
import ComposableArchitecture

public enum DatabaseAction: Equatable {
}

public struct DatabaseEnvironment: Equatable {

}

let databaseReducer = Reducer<NotionDataBase, DatabaseAction, DatabaseEnvironment>.init {
    state, action, environment in

    return .none
}

struct DatabaseView: View {
    let store: Store<NotionDataBase, DatabaseAction>

    init (store: Store<NotionDataBase, DatabaseAction>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(self.store) { viewStore in
            if let title = viewStore.title?.first?.type.value as? NotionText,
               let text = title.content {
                Text(text)
            } else {
                Text("title is nil")
            }
        }
    }
}

struct DatabaseView_Previews: PreviewProvider {
    static var previews: some View {
        DatabaseView(store: .init(
            initialState: NotionDataBase(object: .database, id: "s1234"),
            reducer: databaseReducer,
            environment: DatabaseEnvironment()
            )
        )
    }
}
