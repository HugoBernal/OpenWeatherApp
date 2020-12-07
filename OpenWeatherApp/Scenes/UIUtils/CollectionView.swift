//
//  CollectionView.swift
//  OpenWeatherApp
//
//  Created by Hugo Hernando Bernal Palacio on 5/12/20.
//

import UIKit

//private enum Section {
//    case one
//}
//
//struct Mamarre: Hashable {
//    let a, b, c, d: String
//}
//
////protocol CollectionView where Self: UICollectionView {
////    func updateDataSource(mamarre: Mamarre)
////}
////
////extension ViewableInjection {
////    static func inject() -> CollectionView {
////        CollectionViewImpl()
////    }
////}
//
//class CollectionViewImpl: UICollectionView {
//
//    init() {
//        super.init(frame: .init(x: 10, y: 10, width: 300, height: 400), collectionViewLayout: UICollectionViewCompositionalLayout.getLayout())
//    }
//
//    required init?(coder: NSCoder) {
//        preconditionFailure("init(coder:) has not been implemented")
//    }
//
//    func setDataSource() {
//        let dataSource = UICollectionViewDiffableDataSource<Section, Mamarre>(collectionView: self,
//                                                                              cellProvider: { (collectionView, indexPath, mamarre) -> UICollectionViewCell? in
//                                                                                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.id, for: indexPath) as? CollectionCell
//                                                                                cell?.label.text = mamarre.a
//                                                                                return cell
//                                                                              })
//
//        self.dataSource = dataSource
//    }
//
//    func updateDataSource(mamarre: Mamarre) {
//        self.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.id)
//        self.dataSource = self
//        self.backgroundColor = .white
//        setDataSource()
//
//        var snapshot = NSDiffableDataSourceSnapshot<Section, Mamarre>()
//
//        snapshot.appendSections([Section.one])
//        snapshot.appendItems([mamarre], toSection: .one)
//
//        (dataSource as? UICollectionViewDiffableDataSource)?.apply(snapshot, animatingDifferences: true)
//    }
//
//
//
//    override func numberOfItems(inSection section: Int) -> Int {
//        return 5
//    }
//
//    override func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
//        let cell = self.dequeueReusableCell(withReuseIdentifier: CollectionCell.id, for: indexPath)
//        cell.backgroundColor = .red
//        return cell
//    }
//}
//
//extension CollectionViewImpl: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        5
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = self.dequeueReusableCell(withReuseIdentifier: CollectionCell.id, for: indexPath)
//        cell.backgroundColor = .red
//        return cell
//    }
//
//
//}
//
////extension CollectionViewImpl: CollectionView {
////
////}
//
//
//// MARK: - Layout
//
//private extension UICollectionViewCompositionalLayout {
//    static func getLayout() -> UICollectionViewCompositionalLayout {
//        return UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
//            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
//                                                                heightDimension: .fractionalHeight(1.0)))
//            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
//
//            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
//                                                                           heightDimension: .estimated(50)),
//                                                         subitem: item,
//                                                         count: 1)
//
//            let section = NSCollectionLayoutSection(group: group)
//            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
//
//            return section
//        }
//    }
//}
//
//
//// MARK: - Cell
//
//private class CollectionCell: UICollectionViewCell {
//    static let id = "cellId"
//
//    override var reuseIdentifier: String? { Self.id }
//
//    lazy var label: UILabel = {
//        UILabel()
//    }()
//
//    override func layoutSubviews() {
//        super.contentView.addSubview(label)
//    }
//}
