//
//  NetworkClient.swift
//  OpenWeatherApp
//
//  Created by Hugo Hernando Bernal Palacio on 5/12/20.
//

import Foundation

protocol APINetworkClient {
    func request<Response: Codable>(_ endpoint: Endpoint<Response>, onCompletion: @escaping (Result<Response, Error>) -> ())
}

extension FoundationInjection {
    static func inject() -> APINetworkClient {
        NetworkClient()
    }
}

final class NetworkClient: Foundation {
    struct Dependencies: FoundationDependencies {
        var session: URLSession = .init(configuration: .default)
    }

    var dependencies: Dependencies

    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
}

extension NetworkClient: APINetworkClient {
    func request<Response: Codable>(_ endpoint: Endpoint<Response>, onCompletion: @escaping (Result<Response, Error>) -> ()) {
        guard let urlRequest = endpoint.urlRequest() else {
            return onCompletion(.failure(NetworkClientError.malformedURLRequest))
        }

        let dataTask = self.session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print(error)
                return onCompletion(.failure(error))
            }

            guard let response = response else {
                return onCompletion(.failure(NetworkClientError.invalidURLResponse))
            }

            guard response.hasSuccessfulStatusCode else {
                return onCompletion(.failure(NetworkClientError.failedStatusCode(response.httpStatusCode)))
            }

            guard let data = data,
                  let decodedData = try? endpoint.decoder.decode(Response.self, from: data) else {
                return onCompletion(.failure(NetworkClientError.malformedData))
            }

            onCompletion(.success(decodedData))
        }

        dataTask.resume()
    }
}

// MARK: - Network Errors
enum NetworkClientError: Error {
    case malformedURLRequest
    case invalidURLResponse
    case failedStatusCode(Int)
    case malformedData
}

// MARK: - URL Response
private extension URLResponse {
    var httpStatusCode: Int {
        (self as? HTTPURLResponse)?.statusCode ?? 418
    }

    var hasSuccessfulStatusCode: Bool {
        (200 ..< 300) ~= httpStatusCode
    }
}
