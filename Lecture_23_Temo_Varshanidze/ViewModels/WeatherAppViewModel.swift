import Foundation

final class WeatherAppViewModel {
    private let weatherService = WeatherAppManager()
    
    private(set) var weatherData = [Forecast]()  // external only for read
    
    var onWeatherUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    private var closestForecast: Forecast?
    
    func fetchWeatherData() {
        weatherService.getWeatherData { [weak self] result in
            switch result {
            case .success(let data):
                self?.weatherData = data
                self?.calculateClosestForecast()
                self?.onWeatherUpdated?()
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
    
    private func calculateClosestForecast() {
        let now = Date().timeIntervalSince1970
        closestForecast = weatherData.min(by: { abs($0.dt - now) < abs($1.dt - now) })
    }

    var numberOfRows: Int {
        return weatherData.count
    }

    func forecast(at index: Int) -> Forecast {
        return weatherData[index]
    }
    
    func isClosestForecast(at index: Int) -> Bool {
        return weatherData[index].dt == closestForecast?.dt
    }
}
