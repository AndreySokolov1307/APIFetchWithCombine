//
//  ViewController.swift
//  APIFetch
//
//  Created by Андрей Соколов on 08.02.2024.
//

import UIKit
import Combine

class ViewController: UIViewController {

    var characters = [MoviewCharacters]()
    var cancelable: Set<AnyCancellable> = []
    
    let url = URL(string: "https://rickandmortyapi.com/api/character")
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        NetworkService.shared.fetchCharacters()
            .sink { _ in
                
            } receiveValue: { [weak self] movieCharacters in
                self?.characters = movieCharacters
                print(self?.characters)
            }.store(in: &cancelable)
    }
}

