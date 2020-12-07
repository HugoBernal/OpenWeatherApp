//
//  Weather.swift
//  OpenWeatherApp
//
//  Created by Hugo Hernando Bernal Palacio on 5/12/20.
//

import Foundation

struct Weather: Codable {
    let main: MainData
    let weather: [WeatherData]
    let name: String
}

struct MainData: Codable {
    let temp, pressure, humidity, tempMin, tempMax: Double

    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct WeatherData: Codable {
    let main: String
    let description: String
}
