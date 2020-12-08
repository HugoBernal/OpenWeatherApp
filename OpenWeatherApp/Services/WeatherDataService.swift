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
        var storeManager: StoreManager = inject()
    }

    var dependencies: Dependencies

    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
}

extension WeatherDataServiceAdapter: WeatherDataService {
    func getWeatherData(by name: String, onCompletion: @escaping GetWeatherDataCompletion) {
        self.storeManager.read(by: name) { result in
            switch result {
            case .success(let weather):
                onCompletion(.success(weather))
            case .failure(let error):
                print(error)
                self.networkClient.request(Endpoint<Weather>(query: ["q": name])) { result in
                    switch result {
                    case .success(let weather):
                        self.storeManager.save(model: weather) { result in
                            switch result {
                            case .success():
                                onCompletion(.success(weather))
                            case .failure(let error):
                                print(error)
                                onCompletion(.success(weather))
                            }
                        }
                    case .failure(let error):
                        onCompletion(.failure(error))
                    }
                }
            }
        }
    }

    func getWeatherData(for coordinates: LocationCoordinates, onCompletion: @escaping GetWeatherDataCompletion) {
        self.storeManager.read(by: coordinates) { result in
            switch result {
            case .success(let weather):
                onCompletion(.success(weather))
            case .failure(let error):
                print(error)
                self.networkClient.request(
                    Endpoint<Weather>(query: ["lat": coordinates.latitude,
                                              "lon": coordinates.longitude])) { result in
                    switch result {
                    case .success(let weather):
                        self.storeManager.save(model: weather, coordinates: coordinates) { result in
                            switch result {
                            case .success():
                                onCompletion(.success(weather))
                            case .failure(let error):
                                print(error)
                                onCompletion(.success(weather))
                            }
                        }
                    case .failure(let error):
                        onCompletion(.failure(error))
                    }
                }
            }
        }
    }
}
