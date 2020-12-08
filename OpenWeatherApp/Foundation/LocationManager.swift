//
//  LocationManager.swift
//  OpenWeatherApp
//
//  Created by Hugo Hernando Bernal Palacio on 6/12/20.
//

import Foundation
import CoreLocation

protocol LocationManager {
    func setupLocationManager()
    func getLocation(onCompletion: @escaping (Result<LocationCoordinates, Error>) -> ())
}

extension FoundationInjection {
    static func inject() -> LocationManager {
        LocationManagerImpl()
    }
}

final class LocationManagerImpl: NSObject, Foundation {
    struct Dependencies: FoundationDependencies {
        var locationManager: CLLocationManager = .init()
        var locationResponse: Result<LocationCoordinates, Error> = .failure(LocationErrors.noStoredLocations)
    }

    var dependencies: Dependencies

    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
}

extension LocationManagerImpl: LocationManager {
    func setupLocationManager() {
        self.dependencies.locationManager.delegate = self
        self.dependencies.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.dependencies.locationManager.requestWhenInUseAuthorization()
    }

    func getLocation(onCompletion: @escaping (Result<LocationCoordinates, Error>) -> ()) {
        onCompletion(self.dependencies.locationResponse)
    }
}

extension LocationManagerImpl: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {
            return self.dependencies.locationResponse = .failure(LocationErrors.unableToGetLocation)
        }

        if currentLocation.horizontalAccuracy > 0 {
            self.dependencies.locationManager.stopUpdatingLocation()


            self.dependencies.locationResponse = .success(.init(latitude: String(format: "%.2f", currentLocation.coordinate.latitude),
                                                                longitude: String(format: "%.2f", currentLocation.coordinate.longitude)))
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.dependencies.locationResponse = .failure(error)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            self.dependencies.locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            self.dependencies.locationManager.startUpdatingLocation()
        default:
            self.dependencies.locationResponse = .failure(LocationErrors.locationDeniedOrRestricted)
        }
    }
}

enum LocationErrors: Error {
    case locationDeniedOrRestricted
    case unableToGetLocation
    case noStoredLocations
}
