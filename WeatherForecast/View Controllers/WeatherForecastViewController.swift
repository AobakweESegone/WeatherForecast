//
//  WeatherForecastViewController.swift
//  WeatherForecast
//
//  Created by Aobakwe Segone on 2019/02/05.
//  Copyright © 2019 aobakwesegone. All rights reserved.
//

import UIKit

class WeatherForecastViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var store: WeatherStore!
    var cellViewModels = [ForecastWeatherCell]()
    
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    
    @IBOutlet weak var conditionDescriptionLabel: UILabel!
    @IBOutlet weak var minMaxTemperatureLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    
    @IBOutlet weak var forecastTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(receivedForecastWeather), name: NSNotification.Name(rawValue: "ForecastWeather Available"), object: nil)

//        store.fetchfiveDayWeatherForecast(with: "-25.92", and: "28.14") { (weatherResult) in
//            switch weatherResult {
//            case let .Success(weatherResult):
//                //print("successfully decoded:\n\(weatherResult.list)")
////                self.cellViewModels = weather.list.map {
////                    AESWeatherCell(weekDay: $0.dt_txt, maximimTemperature: $0.main.maximumTemperature, iconURL: URL(string: "https://openweathermap.org/img/w/\($0.weather[0].icon).png")!)
////                }
////                OperationQueue.main.addOperation {
////                    self.forecastTableView.reloadData()
////                }
//
//                                self.store.fetchWeatherIconForWeather(weather: weather.first!, completion: { (imageResult) in
//                                    switch imageResult {
//                                    case let .Success(image):
//                                        // execute on main queue
//                                        OperationQueue.main.addOperation {
//                                            self.currentWeatherIcon.image = image
//                                        }
//                                    case let .Failure(error):
//                                        print("error downloading image: \(error)")
//                                    }
//                            })
//            case let .Failure(error):
//                print("Error fetching weather forecast: \(error)")
//            }
//        }
        
    }
    
    @objc func receivedForecastWeather(notification: Notification) {
        if notification.name.rawValue == "ForecastWeather Available" {
            let forecastWeatherList: WeatherForecastAPI = notification.userInfo!["forecastWeather"] as! WeatherForecastAPI
            
            // fetch weather icons per weather object
            self.cellViewModels = forecastWeatherList.list.map {
                ForecastWeatherCell(weekDay: $0.dt_txt, minimumTemperature: $0.main.minimumTemperature, maximumTemperature: $0.main.maximumTemperature, iconURL: URL(string: "https://openweathermap.org/img/w/\($0.weather[0].icon).png")!)
            }
            OperationQueue.main.addOperation {
                self.forecastTableView.reloadData()
            }
//
//            self.store.fetchWeatherIconForWeather(weather: forecastWeatherList, completion: { (imageResult) in
//                switch imageResult {
//                case let .Success(image):
//                    // execute on main queue
//                    OperationQueue.main.addOperation {
//                        self.currentWeatherIcon.image = image
//                    }
//                case let .Failure(error):
//                    print("error downloading image: \(error)")
//                }
//            })

        }
    }
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weatherCell = cellViewModels[indexPath.row]
        
        let cell: ForecastTableViewCell = tableView.dequeueReusableCell(withIdentifier: "forecastWeatherCell", for: indexPath) as! ForecastTableViewCell;
        
        weatherCell.loadWeatherIcon(completion: { (image) in
            cell.conditionIcon.image = image
        })
        
        cell.minTemperatureLabel.text = "\(weatherCell.minimumTemperature.rounded(.toNearestOrAwayFromZero))"
        cell.maxTemperatureLabel.text = "\(weatherCell.maximumTemperature.rounded(.toNearestOrAwayFromZero))"
        
        return cell
    }

}
