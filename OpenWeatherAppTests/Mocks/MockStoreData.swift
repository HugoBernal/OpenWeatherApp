//
//  MockStoreData.swift
//  OpenWeatherAppTests
//
//  Created by Hugo Hernando Bernal Palacio on 8/12/20.
//

import Foundation
@testable import OpenWeatherApp

class MockStoreManager: StoreManager {
    func read(by name: String, onCompletion: @escaping (Result<Weather, Error>) -> ()) {
        name == "Santiago" ? onCompletion(.success(.mock)) : onCompletion(.failure(StoreErrors.unableToGetDataFromStore))
    }

    func read(by coordinates: LocationCoordinates, onCompletion: @escaping (Result<Weather, Error>) -> ()) {
        coordinates.latitude == "-33.4" && coordinates.longitude == "-70.6" ? onCompletion(.success(.mock)) : onCompletion(.failure(StoreErrors.unableToGetDataFromStore))
    }

    func save(model: Weather, coordinates: LocationCoordinates?, onCompletion: @escaping (Result<Void, Error>) -> ()) {
        guard let lat = coordinates?.latitude, let lon = coordinates?.longitude else {
            return onCompletion(.failure(StoreErrors.unableToStoreData))
        }
        model.name == "Santiago" || (lat == "-33.4" && lon == "-70.6") ? onCompletion(.success(())) : onCompletion(.failure(StoreErrors.unableToStoreData))
    }

    func deleteAll(onCompletion: @escaping (Result<Void, Error>) -> ()) {

    }
}
