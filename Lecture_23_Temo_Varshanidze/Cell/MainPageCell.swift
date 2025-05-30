import UIKit

class MainPageCell: UICollectionViewCell {
    
    static let identifier = "MainPageCell"
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "Tbilisi" 
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        label.textColor = .systemGray
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .systemBlue
        return label
    }()
    
    private let feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemOrange
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .systemBackground
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(cityLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(weatherIconImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(feelsLikeLabel)
        
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        feelsLikeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cityLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            weatherIconImageView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 8),
            weatherIconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 50),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 50),
            
            dateLabel.topAnchor.constraint(equalTo: weatherIconImageView.bottomAnchor, constant: 8),
            dateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            temperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            feelsLikeLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 4),
            feelsLikeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            feelsLikeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with model: Forecast, showFeelsLike: Bool) {
        let date = Date(timeIntervalSince1970: model.dt)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM HH:mm"
        dateLabel.text = formatter.string(from: date)

        descriptionLabel.text = model.weather.first?.main ?? "N/A"
        temperatureLabel.text = "\(Int(model.main.temp))°C"
        
        if showFeelsLike {
            feelsLikeLabel.isHidden = false
            feelsLikeLabel.text = "Feels like: \(Int(model.main.feels_like))°C"
        } else {
            feelsLikeLabel.isHidden = true
        }

        if let icon = model.weather.first?.icon {
            let urlStr = "https://openweathermap.org/img/wn/\(icon)@2x.png"
            if let url = URL(string: urlStr) {
                loadImage(from: url)
            }
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    self.weatherIconImageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}
