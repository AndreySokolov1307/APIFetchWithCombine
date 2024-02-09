//
//  MovieCharacters.swift
//  APIFetch
//
//  Created by Андрей Соколов on 08.02.2024.
//

import Foundation


struct CharactersResponce: Codable {
    let results: [MoviewCharacter]
}

struct MoviewCharacter: Codable, Hashable {
    let name: String
}
