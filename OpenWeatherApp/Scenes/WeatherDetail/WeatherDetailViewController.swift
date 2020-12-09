//
//  WeatherDetailViewController.swift
//  OpenWeatherApp
//
//  Created by Hugo Hernando Bernal Palacio on 7/12/20.
//

import UIKit

protocol WeatherDetailView {
    func layoutWeatherData(with weather: Weather)
}

final class WeatherDetailViewController: BaseViewController, VIPView {
    struct Dependencies: VIPViewDependencies {
        var interactor: WeatherDetailInteractor
    }

    var injector = WeatherDetailInjector()
    lazy var dependencies: Dependencies = { injector.inject(view: self)}()

    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "background1"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .white
        return label
    }()

    lazy var weatherIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "thermometer"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    lazy var forecastLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()

    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 60, weight: .heavy)
        label.textColor = .white
        label.accessibilityIdentifier = "XCTempLabel"
        return label
    }()

    lazy var pressureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()

    lazy var humidityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()

    lazy var tempRangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()

    lazy var forecastStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [weatherIconImageView, forecastLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalCentering
        return stack
    }()

    lazy var additionalInfoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [pressureLabel, humidityLabel, tempRangeLabel, descriptionLabel])
            stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
}

extension WeatherDetailViewController: WeatherDetailView {
    func layoutWeatherData(with weather: Weather) {
        view.backgroundColor = .white

        view.addSubview(backgroundImageView)
        view.addSubview(cityNameLabel)
        view.addSubview(forecastStack)
        view.addSubview(temperatureLabel)
        view.addSubview(additionalInfoStack)

        NSLayoutConstraint.activate([
            backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 1),
            backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 1),
            cityNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            cityNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cityNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            forecastStack.leadingAnchor.constraint(greaterThanOrEqualTo: cityNameLabel.trailingAnchor, constant: 20),
            forecastStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            forecastStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            forecastStack.centerYAnchor.constraint(equalTo: cityNameLabel.centerYAnchor, constant: 1),
            temperatureLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 100),
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 1),
            additionalInfoStack.topAnchor.constraint(greaterThanOrEqualTo: temperatureLabel.bottomAnchor, constant: 200),
            additionalInfoStack.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 1),
            additionalInfoStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])

        cityNameLabel.text = weather.name
        forecastLabel.text = weather.weather[0].main
        temperatureLabel.text = String(describing: weather.main.temp) + "ºC"
        pressureLabel.text = "Pressure: " + String(describing: weather.main.pressure) + " Pa"
        humidityLabel.text = "Humidity: " + String(describing: weather.main.humidity)
        tempRangeLabel.text = "Range: " +  "\(weather.main.tempMin)ºC ~ \(weather.main.tempMax)ºC"
        descriptionLabel.text = weather.weather[0].description
    }
}
