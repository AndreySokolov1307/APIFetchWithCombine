import Foundation
import Combine

fileprivate enum Constants {
    static let url = URL(string: "https://rickandmortyapi.com/api/character")
}

class NetworkService {
    private let url = Constants.url
    
    func fetchCharacters()  -> AnyPublisher<[MoviewCharacters], Error> {
        return URLSession.shared.dataTaskPublisher(for: url!)
            .map { $0.data }
            .decode(type: CharactersResponce.self, decoder: JSONDecoder())
            .map { $0.results }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
