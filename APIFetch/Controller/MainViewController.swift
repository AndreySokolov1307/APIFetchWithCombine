//
//  ViewController.swift
//  APIFetch
//
//  Created by Андрей Соколов on 08.02.2024.
//

import UIKit
import Combine

fileprivate enum Constants {
    static let reuseIdentifier = "ListCell"
    static let navigationTitle = "All Characters"
}

fileprivate enum Section: CaseIterable {
    case main
}

final class MainViewController: UIViewController {

    private var mainView: MainView!
    private var characters = [MoviewCharacter]()
    private var cancellable: Set<AnyCancellable> = []
    private var dataSource: UICollectionViewDiffableDataSource<Section, MoviewCharacter>!
    private var moviewCharactersSnapshot: NSDiffableDataSourceSnapshot<Section, MoviewCharacter> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MoviewCharacter>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(characters)
        
        return snapshot
    }

    override func loadView() {
        mainView = MainView()
        self.view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.navigationTitle
        cellRegistration()
        fetchCharacters()
        createDataSource()
    }
    
    private func fetchCharacters() {
        NetworkService.shared.fetchCharacters()
            .sink { _ in
                
            } receiveValue: { [weak self] movieCharacters in
                guard let self = self else { return }
                self.characters = movieCharacters
                self.dataSource.apply(self.moviewCharactersSnapshot)
            }.store(in: &cancellable)
    }
    
    private func cellRegistration() {
        mainView.collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: Constants.reuseIdentifier)
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MoviewCharacter>(collectionView: mainView.collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewListCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentifier, for: indexPath) as! UICollectionViewListCell
            
            var content = UIListContentConfiguration.valueCell()
            content.text = item.name
            cell.contentConfiguration = content
            
            return cell
        })
        dataSource.apply(moviewCharactersSnapshot)
    }
}

