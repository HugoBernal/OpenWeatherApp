//
//  CitiesViewController.swift
//  OpenWeatherApp
//
//  Created by Hugo Hernando Bernal Palacio on 5/12/20.
//

import UIKit

enum Section {
    case one
}

protocol CitiesView {
    func layoutView(with cities: [String])
    func startLoading()
    func stopLoading()
    func showErrorView(with description: String)
    func goToDetailView(with configuration: WeatherDetailInjector)
}

class CitiesViewController: BaseViewController, VIPView {
    struct Dependencies: VIPViewDependencies {
        var interactor: CitiesInteractor
    }

    var injector = CitiesInjector()
    lazy var dependencies: Dependencies = { self.injector.inject(view: self) }()

    lazy var dataSource: UICollectionViewDiffableDataSource<Section, String> = {
        let dataSource = UICollectionViewDiffableDataSource<Section, String>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, cities) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.id, for: indexPath) as? CollectionCell
                cell?.label.text = cities
                cell?.label.textColor = .black
                cell?.backgroundColor = #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
                return cell
            })

        return dataSource
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: .getLayout())
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        collectionView.accessibilityIdentifier = "XCTCollectionView"

        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.id)
        return collectionView
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
}

extension CitiesViewController: CitiesView {
    func layoutView(with cities: [String]) {
        navigationItem.title = "Weather"

        view.addSubview(collectionView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),

            activityIndicator.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            activityIndicator.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1)
        ])

        updateDataSource(with: cities)
    }

    func startLoading() {
        collectionView.alpha = 0.5
        activityIndicator.startAnimating()
    }

    func stopLoading() {
        collectionView.alpha = 1
        activityIndicator.stopAnimating()
    }

    func showErrorView(with description: String) {
        self.showAlert(with: description)
    }

    func goToDetailView(with configuration: WeatherDetailInjector) {
        let weatherDetailView = WeatherDetailViewController()
        weatherDetailView.injector = configuration
        navigationController?.pushViewController(weatherDetailView, animated: true)
    }
}

private extension CitiesViewController {
    func updateDataSource(with cities: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()

        snapshot.appendSections([Section.one])
        snapshot.appendItems(cities, toSection: .one)

        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
}

extension CitiesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.allSatisfy({ $0 == 0}) {
            self.interactor.getWeatherForCurrentLocation()
        } else {
            self.interactor.getWeather(for: indexPath.row)
        }
    }
}

// MARK: - CollectionViewLayout

private extension UICollectionViewLayout {
    static func getLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                                heightDimension: .fractionalHeight(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                                           heightDimension: .estimated(80)),
                                                         subitem: item,
                                                         count: 2)
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30)

            return section
        }
    }
}
