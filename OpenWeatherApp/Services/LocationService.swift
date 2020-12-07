//
//  LocationService.swift
//  OpenWeatherApp
//
//  Created by Hugo Hernando Bernal Palacio on 6/12/20.
//

import Foundation

protocol LocationService {
    func setupLocationManager()
    func getCurrentLocation(onCompletion: @escaping (Result<LocationCoordinates, Error>) -> ())
}

extension ServiceInjection {
    static func inject() -> LocationService {
        LocationServiceImpl()
    }
}

final class LocationServiceImpl: Service {
    struct Dependencies: ServiceDependencies {
        var locationManager: LocationManager = inject()
    }

    var dependencies: Dependencies

    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
}

extension LocationServiceImpl: LocationService {
    func setupLocationManager() {
        self.locationManager.setupLocationManager()
    }

    func getCurrentLocation(onCompletion: @escaping (Result<LocationCoordinates, Error>) -> ()) {
        self.locationManager.getLocation(onCompletion: onCompletion)
    }
}
