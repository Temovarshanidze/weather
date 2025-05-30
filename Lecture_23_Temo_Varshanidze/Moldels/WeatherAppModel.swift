import Foundation


struct WeatherForecastResponse: Codable {
    let list: [Forecast]
}


struct Forecast: Codable {
    let dt: TimeInterval
    let main: Main
    let weather: [Weather]
    let dt_txt: String
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}
