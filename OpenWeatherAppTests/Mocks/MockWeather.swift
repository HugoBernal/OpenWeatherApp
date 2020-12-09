//
//  MockWeather.swift
//  OpenWeatherAppTests
//
//  Created by Hugo Hernando Bernal Palacio on 8/12/20.
//

import Foundation
@testable import OpenWeatherApp

extension Weather {
    static var mock: Weather = .init(main: .init(temp: 26.9,
                                                 pressure: 1050.0,
                                                 humidity: 23.0,
                                                 tempMin: 26.0,
                                                 tempMax: 28.33),
                                     weather: [
                                        .init(main: "Clear",
                                              description: "clear sky")
                                     ],
                                     name: "Santiago")
}
