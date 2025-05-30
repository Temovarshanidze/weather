
import Foundation

final class WeatherAppManager {
    static let shared = WeatherAppManager()
    
     init() {}
    let serialQueue = DispatchQueue(label: "com.example.WeatherAppManager") // სერიალ რიგი
    
    func getWeatherData(completion: @escaping (Result<[Forecast], Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=41.6938&lon=44.8015&units=metric&appid=f09906a2ca221c4a3cb46e34b6d87560"
        NetworkManager.shared.fetchData(urlsString: urlString) { (result: Result<WeatherForecastResponse, Error>) in
            self.serialQueue.async {
                switch result {
                case .success(let weatherData):
                    completion(.success(weatherData.list)) // ✅ აბრუნებ მხოლოდ list-ს
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
