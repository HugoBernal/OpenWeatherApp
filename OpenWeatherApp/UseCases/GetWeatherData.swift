//
//  GetWeatherData.swift
//  OpenWeatherApp
//
//  Created by Hugo Hernando Bernal Palacio on 5/12/20.
//

import Foundation

protocol GetWeatherData {
    func getWeatherData(by name: String, onCompletion: @escaping GetWeatherDataCompletion)
    func getWeatherData(for coordinates: LocationCoordinates, onCompletion: @escaping GetWeatherDataCompletion)
}

extension UseCaseInjection {
    static func inject() -> GetWeatherData {
        GetWeatherDataAdapter()
    }
}

final class GetWeatherDataAdapter: UseCase {
    struct Dependencies: UseCaseDependencies {
        var weatherService: WeatherDataService = inject()
    }

    var dependencies: Dependencies

    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
}

extension GetWeatherDataAdapter: GetWeatherData {
    func getWeatherData(by name: String, onCompletion: @escaping GetWeatherDataCompletion) {
        self.weatherService.getWeatherData(by: name, onCompletion: onCompletion)
    }

    func getWeatherData(for coordinates: LocationCoordinates, onCompletion: @escaping GetWeatherDataCompletion) {
        self.weatherService.getWeatherData(for: coordinates, onCompletion: onCompletion)
    }
}
