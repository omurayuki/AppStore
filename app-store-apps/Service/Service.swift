import Foundation

class Service {
    static let shared = Service()
    
    func fetchApps(completion: @escaping(([Result], Error?) -> Void)) {
        let urlString = "https://itunes.apple.com/search?term=instagram&entity=software"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion([], error)
                return
            }
            do {
                guard let data = data else { return }
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                completion(searchResult.results, nil)
            } catch let jsonErr {
                completion([], jsonErr)
            }
        }.resume()
    }
}
