//
//  WeatherDetailInteractor.swift
//  OpenWeatherApp
//
//  Created by Hugo Hernando Bernal Palacio on 7/12/20.
//

import Foundation

protocol WeatherDetailInteractor {

}

final class WeatherDetailInteractorImpl: VIPInteractor {
    struct Dependencies: VIPInteractorDependencies {
        var presenter: WeatherDetailPresenter
    }

    struct Configuration {
        var weather: Weather
    }

    var dependencies: Dependencies
    var configuration: Configuration

    init(dependencies: Dependencies, configuration: Configuration) {
        self.dependencies = dependencies
        self.configuration = configuration
    }

    func sceneDidLoad() {
        self.presenter.setupView(with: configuration.weather)
    }
}

//extension WeatherDetailInteractorImpl.Dependencies {
//    init(presenter: WeatherDetailPresenter) {
//        self.presenter = presenter
//    }
//}

extension WeatherDetailInteractorImpl: WeatherDetailInteractor {

}
