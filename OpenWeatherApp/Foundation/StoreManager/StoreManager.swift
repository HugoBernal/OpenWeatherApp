//
//  StoreManager.swift
//  OpenWeatherApp
//
//  Created by Hugo Hernando Bernal Palacio on 8/12/20.
//

import Foundation
import CoreData

protocol StoreManager {
    func save(model: Weather, coordinates: LocationCoordinates?, onCompletion: @escaping (Result<Void, Error>) -> ())
    func read(by name: String, onCompletion: @escaping (Result<Weather, Error>) -> ())
    func read(by coordinates: LocationCoordinates, onCompletion: @escaping (Result<Weather, Error>) -> ())
    func deleteAll(onCompletion: @escaping (Result<Void, Error>) -> ())
}

extension StoreManager {
    func save(model: Weather, coordinates: LocationCoordinates? = nil, onCompletion: @escaping (Result<Void, Error>) -> ()) {
        save(model: model, coordinates: coordinates, onCompletion: onCompletion)
    }
}

extension FoundationInjection {
    static func inject() -> StoreManager {
        StoreManagerImpl()
    }
}

final class StoreManagerImpl: Foundation {
    struct Dependencies: FoundationDependencies {
        lazy var container: NSPersistentContainer = loadPersistentStores()
        lazy var context: NSManagedObjectContext = { self.container.viewContext }()
        var request: NSFetchRequest<CDWeather> = CDWeather.fetchRequest()
    }

    var dependencies: Dependencies

    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
}

extension StoreManagerImpl: StoreManager {
    func save(model: Weather, coordinates: LocationCoordinates? = nil, onCompletion: (Result<Void, Error>) -> ()) {
        CDWeather.map(from: model, coordinates: coordinates, context: self.dependencies.context)
        if self.dependencies.context.hasChanges {
            do {
                try self.dependencies.context.save()
                onCompletion(.success(()))
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                onCompletion(.failure(StoreErrors.unableToStoreData))
            }
        }
    }

    func read(by name: String, onCompletion: @escaping (Result<Weather, Error>) -> ()) {
        guard let cdWeather = try? self.dependencies.context.fetch(self.request) else {
            return onCompletion(.failure(StoreErrors.unableToFetchFromRequest))
        }

        guard let weather = cdWeather.first(where: { $0.name == name })?.mapToWeather() else {
            return onCompletion(.failure(StoreErrors.unableToGetDataFromStore))
        }

        onCompletion(.success(weather))
    }

    func read(by coordinates: LocationCoordinates, onCompletion: @escaping (Result<Weather, Error>) -> ()) {
        guard let cdWeather = try? self.dependencies.context.fetch(self.request) else {
            return onCompletion(.failure(StoreErrors.unableToFetchFromRequest))
        }

        guard let weather = cdWeather.first(where: { $0.lat == coordinates.latitude && $0.lon == coordinates.longitude })?.mapToWeather() else {
            return onCompletion(.failure(StoreErrors.unableToGetDataFromStore))
        }

        onCompletion(.success(weather))
    }

    func deleteAll(onCompletion: @escaping (Result<Void, Error>) -> ()) {
        guard let cdWeather = try? self.dependencies.context.fetch(self.request) else {
            return onCompletion(.failure(StoreErrors.unableToFetchFromRequest))
        }

        cdWeather.forEach { self.dependencies.context.delete($0) }
        onCompletion(.success(()))
    }
}

private extension StoreManagerImpl.Dependencies {
    func loadPersistentStores() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "OpenWeatherApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }
}

enum StoreErrors: Error {
    case unableToStoreData
    case unableToFetchFromRequest
    case unableToGetDataFromStore
}

// MARK: App Life cycle

protocol AppLifeCycleStorageManager {
    func saveContext()
}

extension FoundationInjection {
    static func inject() -> AppLifeCycleStorageManager {
        StoreManagerImpl()
    }
}

extension StoreManagerImpl: AppLifeCycleStorageManager {
    func saveContext() {
        if self.dependencies.context.hasChanges {
            do {
                try self.dependencies.context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: CoreData model

extension CDWeather {
    @discardableResult
    static func map(from weather: Weather, coordinates: LocationCoordinates?, context: NSManagedObjectContext) -> CDWeather {
        let cdWeather = CDWeather(context: context)
        let cdMainData = CDMainData(context: context)
        let cdWeatherData = CDWeatherData(context: context)

        cdMainData.temp = weather.main.temp
        cdMainData.pressure = weather.main.pressure
        cdMainData.humidity = weather.main.humidity
        cdMainData.tempMin = weather.main.tempMin
        cdMainData.tempMax = weather.main.tempMax

        cdWeatherData.main = weather.weather[0].main
        cdWeatherData.weatherDescription = weather.weather[0].description

        cdWeather.name = weather.name

        if let doubleCoordinates = coordinates {
            cdWeather.lat = doubleCoordinates.latitude
            cdWeather.lon = doubleCoordinates.longitude
        }

        cdWeather.main = cdMainData
        cdWeather.weather = [cdWeatherData]

        return cdWeather
    }

    func mapToWeather() -> Weather? {
        guard let main = self.main,
              let weatherData = self.weather?.allObjects as? [CDWeatherData],
              let mainWeather = weatherData[0].main,
              let weatherDescription = weatherData[0].weatherDescription,
              let name = self.name else {
            return nil
        }
        return Weather(main: .init(temp: main.temp,
                                   pressure: main.pressure,
                                   humidity: main.humidity,
                                   tempMin: main.tempMin,
                                   tempMax: main.tempMax),
                weather: [
                    .init(main: mainWeather,
                          description: weatherDescription)
                ],
                name: name)
    }
}
