import Foundation
import Combine

fileprivate enum Constants {
    static let url = URL(string: "https://rickandmortyapi.com/api/character")
}

fileprivate enum NetworkErrors: Error {
    case invalidStatusCode
}

class NetworkService {
    static let shared = NetworkService()
    
    private let url = Constants.url
    
    func fetchCharacters()  -> AnyPublisher<[MoviewCharacter], Error> {
        return URLSession.shared.dataTaskPublisher(for: url!)
            .tryMap { (data, responce) in
                guard let responce = responce as? HTTPURLResponse,
                      responce.statusCode == 200 else {
                    throw NetworkErrors.invalidStatusCode
                }
                return data
            }
            .decode(type: CharactersResponce.self, decoder: JSONDecoder())
            .map { $0.results }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
