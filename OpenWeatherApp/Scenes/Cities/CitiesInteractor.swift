//
//  CitiesInteractor.swift
//  OpenWeatherApp
//
//  Created by Hugo Hernando Bernal Palacio on 5/12/20.
//

import Foundation

protocol CitiesInteractor {
    func getWeatherForCurrentLocation()
    func getWeather(for cityIndex: Int)
}

final class CitiesInteractorImpl: VIPInteractor {
    struct Dependencies: VIPInteractorDependencies {
        var presenter: CitiesPresenter
        var getWeatherData: GetWeatherData = inject()
        var getCurrentLocation: GetCurrentLocation = inject()
        var cities: [String] = inject()
    }

    var dependencies: Dependencies

    init(dependencies: Dependencies, configuration: ()) {
        self.dependencies = dependencies
    }

    func sceneDidLoad() {
        self.presenter.setupView(with: self.cities)
        self.getCurrentLocation.setupLocationManager()
    }
}

extension CitiesInteractorImpl.Dependencies {
    init(presenter: CitiesPresenter) {
        self.presenter = presenter
    }
}

extension CitiesInteractorImpl: CitiesInteractor {
    func getWeatherForCurrentLocation() {
        self.presenter.startLoading()
        self.getCurrentLocation.getCurrentLocation { result in
            switch result {
            case .success(let coordinates):
                self.getWeatherData.getWeatherData(for: coordinates) { result in
                    switch result {
                    case .success(let weather):
                        var weatherDetailInjector = WeatherDetailInjector()
                        weatherDetailInjector.interactorConfiguration = .init(weather: weather)
                        self.presenter.showDetail(with: weatherDetailInjector)

                    case .failure(let error):
                        self.presenter.setupErrorView(with: error)
                    }
                }
            case .failure(let error):
                self.presenter.setupErrorView(with: error)
            }

            self.presenter.stopLoading()
        }
    }

    func getWeather(for cityIndex: Int) {
        self.presenter.startLoading()
        self.getWeatherData.getWeatherData(by: self.cities[cityIndex]) { result in
            switch result {
            case .success(let weather):
                var weatherDetailInjector = WeatherDetailInjector()
                weatherDetailInjector.interactorConfiguration = .init(weather: weather)
                self.presenter.showDetail(with: weatherDetailInjector)
            case .failure(let error):
                self.presenter.setupErrorView(with: error)
            }
            self.presenter.stopLoading()
        }
    }
}

extension InteractionInjection {
    static func inject() -> [String] {
        [
            "Current Location",
            "Buenos Aires",
            "Santiago",
            "Montevideo",
            "Asuncion",
            "La Paz",
            "Brasilia",
            "Lima",
            "Quito",
            "Bogota",
            "Medellin",
            "Caracas",
            "Mexico city",
            "Los Angeles",
            "San Francisco",
            "New York",
            "Toronto",
            "Montreal",
            "Madrid",
            "Lisboa",
            "Londres",
            "Paris",
            "Berlin",
            "Roma",
            "Amsterdam",
            "Moscow",
            "Istanbul",
            "Oslo",
            "Stockholm",
            "Cairo",
            "Johannesburg",
            "New Delhi",
            "Beijin",
            "Tokio",
            "Seoul",
            "Sydney",
            "Auckland"
        ]
    }
}
