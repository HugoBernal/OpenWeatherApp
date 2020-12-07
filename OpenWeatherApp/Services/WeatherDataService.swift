//
//  WeatherDataService.swift
//  OpenWeatherApp
//
//  Created by Hugo Hernando Bernal Palacio on 5/12/20.
//

import Foundation

typealias GetWeatherDataCompletion = (Result<Weather, Error>) -> ()

protocol WeatherDataService {
    func getWeatherData(by name: String, onCompletion: @escaping GetWeatherDataCompletion)
    func getWeatherData(for coordinates: LocationCoordinates, onCompletion: @escaping GetWeatherDataCompletion)
}

extension ServiceInjection {
    static func inject() -> WeatherDataService {
        WeatherDataServiceAdapter()
    }
}

final private class WeatherDataServiceAdapter: Service {
    struct Dependencies: ServiceDependencies {
        var networkClient: APINetworkClient = inject()
    }

    var dependencies: Dependencies

    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
}

extension WeatherDataServiceAdapter: WeatherDataService {
    func getWeatherData(by name: String, onCompletion: @escaping GetWeatherDataCompletion) {
        self.networkClient.request(
            Endpoint<Weather>(query: ["q": name]),
            onCompletion: onCompletion)
    }

    func getWeatherData(for coordinates: LocationCoordinates, onCompletion: @escaping GetWeatherDataCompletion) {
        self.networkClient.request(
            Endpoint<Weather>(query: ["lat": coordinates.latitude,
                                      "lon": coordinates.longitude]),
            onCompletion: onCompletion)
    }
}
