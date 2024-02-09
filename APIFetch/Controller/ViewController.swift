//
//  ViewController.swift
//  APIFetch
//
//  Created by Андрей Соколов on 08.02.2024.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @Published var characters = [MoviewCharacters]()
    var cancelable: Set<AnyCancellable> = []
    
    let url = URL(string: "https://rickandmortyapi.com/api/character")
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        fetchCharacters()
            .sink { _ in
                
            } receiveValue: { [weak self] movieCharacters in
                self?.characters = movieCharacters
                print(self?.characters)
            }.store(in: &cancelable)
    }
    
    func fetchCharacters()  -> AnyPublisher<[MoviewCharacters], Error> {
        return URLSession.shared.dataTaskPublisher(for: url!)
            .map { $0.data }
            .decode(type: CharactersResponce.self, decoder: JSONDecoder())
            .map { $0.results }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

