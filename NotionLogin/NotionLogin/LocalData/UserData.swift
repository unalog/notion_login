//
//  UserData.swift
//  NotionLogin
//
//  Created by una on 2021/12/21.
//

import Foundation

enum UserDataKey: String {

    case token
    case workspaceId
    case botId
}

extension UserDataKey {
    var value: Any? {
        get { UserDefaults.standard.object(forKey: self.rawValue) }
    }

    func save(_ value: Any?) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
    }
}
