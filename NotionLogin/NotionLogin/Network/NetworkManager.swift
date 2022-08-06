//
//  NetworkManager.swift
//  NotionLogin
//
//  Created by una on 2021/12/21.
//

import Foundation
import Combine
import SwiftyJSON

extension Encodable {
    var jsonData: Data? {
        if let json = try? JSONEncoder().encode(self) {
            return json
        }
        return nil
    }

    var dictionary: [String: String]? {
        let dict = try? JSONDecoder().decode([String: String].self, from: JSONEncoder().encode(self))
        return dict
    }
}

public enum NetworkError: Equatable, LocalizedError {
    case unknown
    case parsing
    case sessionExpired
    case sessionInvalid
    case requestToken
    case notionError(status: Int, code: String, message: String)

    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "알수 없는 오류"
        case .parsing:
            return "parsing 오류"
        case .sessionExpired:
            return "토큰 만료"
        case .sessionInvalid:
            return "토큰 무효화"
        case .requestToken:
            return "토큰 요청중"
        case let .notionError(_, _, message):
            return message
        }
    }

    static func makeNotionError(data: Data) -> NetworkError? {
        guard let json = try? JSON(data: data) else { return nil }
        guard let status = json["status"].int  else { return nil }
        guard let code = json["code"].string  else { return nil }
        guard let message = json["message"].string  else { return nil }

        return NetworkError.notionError(status: status, code: code, message: message)
    }
}

final class NetworkManger {

    fileprivate func makeURLString(api: NetworkAPI) -> URL? {
        guard api.method == .get else { return URL(string: api.url) }
        guard var urlComponents = URLComponents(string: api.url) else { return nil }
        guard let dic = api.params.dictionary else { return nil}

        dic.forEach { key, value in
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
        }

        return urlComponents.url
    }

    fileprivate func makeURLRequest(api: NetworkAPI) -> URLRequest? {
        guard let url = makeURLString(api: api) else { return nil }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method.rawValue

        if api.method == .post {

            if let jsonData = api.params.jsonData,
               let jsonString = String(data: jsonData, encoding: .utf8)
            {
                print(jsonString)
                urlRequest.httpBody = jsonData
            }
        }

        api.header.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("2021-08-16", forHTTPHeaderField: "Notion-Version")

        if let token = UserDataKey.token.value as? String {
            if urlRequest.allHTTPHeaderFields?.keys.contains(where: { $0 == "Authorization"}) == false {
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }

        return urlRequest
    }

    func request(_ api: NetworkAPI) -> AnyPublisher<Data, NetworkError> {
        
        guard let request = makeURLRequest(api: api) else {
            return Fail(error: NetworkError.unknown)
                .eraseToAnyPublisher()
        }

        return URLSession(configuration: URLSessionConfiguration.default)
            .dataTaskPublisher(for: request)
            .tryMap({ data, response -> Data in

                let successRange = 200..<300

                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    throw NetworkError.unknown
                }

                if !successRange.contains(statusCode) {
                    print("\(request.url?.absoluteString ?? "") -> \(statusCode)")

                    if let notionError = NetworkError.makeNotionError(data: data) {
                        print(notionError.localizedDescription)
                        throw notionError
                    }
                    throw NetworkError.unknown
                }

                return data
            })
            .mapError{ ($0 as? NetworkError) ?? NetworkError.unknown }
            .eraseToAnyPublisher()

    }
}
