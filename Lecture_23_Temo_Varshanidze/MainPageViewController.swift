import UIKit

class MainPageViewController: UIViewController {
    
    private let weatherViewModel =  WeatherAppViewModel()
    
    
    private  var weatherCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .cyan
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callAllFunctions()
        
    }

    private func callAllFunctions() {
        view.backgroundColor = .systemBlue
        setUpUI()
        fetchWeatherData()
    }

    private func setUpUI() {
        view.addSubview(weatherCollectionView)
        
        weatherCollectionView.dataSource = self
        weatherCollectionView.delegate = self
        weatherCollectionView.register(MainPageCell.self, forCellWithReuseIdentifier: "MainPageCell")
        
        NSLayoutConstraint.activate([
            weatherCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weatherCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            weatherCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            weatherCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func fetchWeatherData() {
        weatherViewModel.fetchWeatherData()
        weatherViewModel.onWeatherUpdated = { [weak self] in
            DispatchQueue.main.async {
                print("Weather data updated")
                self?.weatherCollectionView.reloadData()
            }
        }
        
        weatherViewModel.onError = { error in
            print("Error fetching weather data: \(error)")
        }
    }
}


extension MainPageViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherViewModel.numberOfRows
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainPageCell", for: indexPath) as? MainPageCell
        let forecast = weatherViewModel.forecast(at: indexPath.item)
        let isClosest = weatherViewModel.isClosestForecast(at: indexPath.item)
        cell?.configure(with: forecast, showFeelsLike: isClosest)
        return cell ?? UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32  
        return CGSize(width: width, height: 180)
    }
}

import SwiftUI
#Preview {
    MainPageViewController()
}
