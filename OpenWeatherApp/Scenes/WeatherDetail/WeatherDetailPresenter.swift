//
//  WeatherDetailPresenter.swift
//  OpenWeatherApp
//
//  Created by Hugo Hernando Bernal Palacio on 7/12/20.
//

import Foundation

protocol WeatherDetailPresenter {
    func setupView(with weather: Weather)
}

final class WeatherDetailPresenterImpl: VIPPresenter {
    struct Dependencies: VIPPresenterDependencies {
        var view: WeatherDetailView
    }

    var dependencies: Dependencies

    init(dependencies: Dependencies, configuration: ()) {
        self.dependencies = dependencies
    }
}

extension WeatherDetailPresenterImpl: WeatherDetailPresenter {
    func setupView(with weather: Weather) {
        self.view.layoutWeatherData(with: weather)
    }
}
