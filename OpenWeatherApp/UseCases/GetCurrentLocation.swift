//
//  GetCurrentLocation.swift
//  OpenWeatherApp
//
//  Created by Hugo Hernando Bernal Palacio on 6/12/20.
//

import Foundation

protocol GetCurrentLocation {
    func setupLocationManager()
    func getCurrentLocation(onCompletion: @escaping (Result<LocationCoordinates, Error>) -> ())
}

extension UseCaseInjection {
    static func inject() -> GetCurrentLocation {
        GetCurrentLocationImpl()
    }
}

final class GetCurrentLocationImpl: UseCase {
    struct Dependencies: UseCaseDependencies {
        var locationService: LocationService = inject()
    }

    var dependencies: Dependencies

    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
}

extension GetCurrentLocationImpl: GetCurrentLocation {
    func setupLocationManager() {
        self.locationService.setupLocationManager()
    }

    func getCurrentLocation(onCompletion: @escaping (Result<LocationCoordinates, Error>) -> ()) {
        self.locationService.getCurrentLocation(onCompletion: onCompletion)
    }
}
