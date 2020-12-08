//
//  Endpoint.swift
//  OpenWeatherApp
//
//  Created by Hugo Hernando Bernal Palacio on 5/12/20.
//

import Foundation

struct Endpoint<Response> {
    let baseURL: String
    let path: String
    let query: [String: String]?
    let method: String
    let headers: [String: String]
    let decoder: JSONDecoder

    init(_ baseURL: String = "http://api.openweathermap.org/data/2.5/weather",
         path: String = "",
         query: [String: String] = [:],
         method: String = "GET",
         headers: [String: String] = [:],
         decoder: JSONDecoder = .dateDecoder) {
        self.baseURL = baseURL
        self.path = path
        self.query = query
        self.method = method
        self.headers = headers
        self.decoder = decoder
    }

    func urlRequest() -> URLRequest? {
        guard let url = getURL() else { return nil }

        var request = URLRequest(url: url)
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        request.httpMethod = method

        return request
    }
}

private extension Endpoint {
    func getURL() -> URL? {
        var url = URLComponents(string: baseURL)

        if !path.isEmpty {
            url?.path = path
        }

        url?.queryItems = query.map { $0.map { URLQueryItem(name: $0.key, value: $0.value) } }

        url?.queryItems?.append(.init(name: "appid", value: "235c44fd3b2c6d04eb25c42b59e70f27"))
        url?.queryItems?.append(.init(name: "units", value: "metric"))

        return url?.url
    }
}

private extension JSONDecoder {
    static var dateDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }
}
