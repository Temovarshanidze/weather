import Foundation

enum NetworkManagerError: Error {
    case wrongResponse
    case statusCodeError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    let   concureceQueue = DispatchQueue(label: "com.example.concurrentQueue", attributes: .concurrent) // ქონქურენსი
    
    func fetchData<T: Codable>(urlsString: String , completion: @escaping (Result<T, Error>) -> Void){
        let url = URL(string: urlsString)
        let urlrequest = URLRequest(url: url!)
        
        URLSession.shared.dataTask(with: urlrequest) { (data, response, error) in
            if let error = error {
                self.concureceQueue.async {
                    completion(.failure(error))
                }
                return
            }
            guard let responseData = response as? HTTPURLResponse else {
                self.concureceQueue.async {
                    completion(.failure(NetworkManagerError.wrongResponse))
                }
                return
            }
            
            guard(200...299).contains(responseData.statusCode) else {
                self.concureceQueue.async {
                    completion(.failure(NetworkManagerError.statusCodeError))
                }
                return
            }
            guard let data = data else {
                return
            }
            do {
                let decoder =  JSONDecoder()
                let object = try decoder.decode(T.self, from: data)
                self.concureceQueue.async {
                    completion(.success(object))
                }
            } catch {
                self.concureceQueue.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
