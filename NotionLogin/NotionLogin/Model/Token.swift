//
//  Token.swift
//  NotionLogin
//
//  Created by una on 2021/12/21.
//

import Foundation

public struct Token: Codable, Equatable {

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case workspaceId = "workspace_id"
        case workspaceName = "workspace_name"
        case workspaceIcon = "workspace_icon"
        case botId = "bot_id"
    }

    public let accessToken: String
    public let workspaceId: String
    public let workspaceName: String?
    public let workspaceIcon: String?
    public let botId: String
    //let owner: String


    public init(
        accessToken: String,
        workspaceId: String,
        workspaceName: String?,
        workspaceIcon: String?,
        botId: String
    ) {
            self.accessToken = accessToken
            self.workspaceId = workspaceId
            self.workspaceName = workspaceName
            self.workspaceIcon = workspaceIcon
            self.botId = botId
    }
}

