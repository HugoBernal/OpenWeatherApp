//
//  CitiesPresenter.swift
//  OpenWeatherApp
//
//  Created by Hugo Hernando Bernal Palacio on 5/12/20.
//

import Foundation

protocol CitiesPresenter {
    func setupView(with cities: [String])
    func startLoading()
    func stopLoading()
    func setupErrorView(with error: Error)
    func showDetail(for weather: Weather)
}

final class CitiesPresenterImpl: VIPPresenter {
    struct Dependencies: VIPPresenterDependencies {
        var view: CitiesView
        var queue: DispatchQueue = .main
    }

    var dependencies: Dependencies

    init(dependencies: Dependencies, configuration: ()) {
        self.dependencies = dependencies
    }
}

extension CitiesPresenterImpl.Dependencies {
    init(view: CitiesView) {
        self.view = view
    }
}

extension CitiesPresenterImpl: CitiesPresenter {
    func setupView(with cities: [String]) {
        self.view.layoutView(with: cities)
    }

    func startLoading() {
        self.queue.async {
            self.view.startLoading()
        }
    }

    func stopLoading() {
        self.queue.async {
            self.view.stopLoading()
        }
    }

    func setupErrorView(with error: Error) {
        self.queue.async {
            self.view.showErrorView(with: error.description)
        }
    }

    func showDetail(for weather: Weather) {
        self.queue.async {
            self.view.goToDetailView(with: weather)
        }

    }
}

private extension Error {
    var description: String {
        switch self {
        case is NetworkClientError:
            return "Unable to reach Weather service."
        case is LocationErrors:
            return "Unable to reach location service."
        default:
            return "Unknown error."
        }
    }
}
