//
//  MockNetworkClient.swift
//  OpenWeatherAppTests
//
//  Created by Hugo Hernando Bernal Palacio on 8/12/20.
//

import Foundation
@testable import OpenWeatherApp

class MockNetworkClient: APINetworkClient {
    func request<Response>(_ endpoint: Endpoint<Response>, onCompletion: @escaping (Result<Response, Error>) -> ()) where Response : Decodable, Response : Encodable {
        if endpoint.query?.contains(where: { $0.value == "Santiago" }) ?? false {
            guard let data = try? JSONEncoder().encode(Weather.mock) else {
                return onCompletion(.failure(NetworkClientError.malformedData))
            }

            guard let decodedData = try? JSONDecoder().decode(Response.self, from: data) else {
                return onCompletion(.failure(NetworkClientError.malformedData))
            }

            onCompletion(.success(decodedData))
        } else {
            onCompletion(.failure(NetworkClientError.malformedURLRequest))
        }

    }
}
