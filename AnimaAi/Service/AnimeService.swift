
import Combine
import UIKit



class AnimeService{
    static var baseUrlComponents: URLComponents {
         var urlComponents = URLComponents()
         urlComponents.scheme = "https"
         urlComponents.host = "kitsu.io"
         return urlComponents
     }
    
    static var limit: Int {return 20}
    
    static func fetchAnimesData(page: Int, sort: String) -> AnyPublisher<Animes, Error> {
         var urlComponents = baseUrlComponents
         urlComponents.path = "/api/edge/anime"
        
        urlComponents.queryItems = [
             URLQueryItem(name: "page[offset]", value: String((page-1)*limit)),
             URLQueryItem(name: "page[limit]", value: String(limit)),
             URLQueryItem(name: "sort", value: sort)
         ]
         
         guard let url = urlComponents.url else {
             return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
         }
         
         var request = URLRequest(url: url)
         request.httpMethod = "GET"
         
         return URLSession.shared.dataTaskPublisher(for: request)
             .retry(3)
             .tryMap { (data, response) -> Data in
                 guard let httpResponse = response as? HTTPURLResponse,
                       httpResponse.statusCode == 200 else {
                     throw URLError(.badServerResponse)
                 }
                 return data
             }
             .decode(type: Animes.self, decoder: JSONDecoder())
             .eraseToAnyPublisher()
     }
}
