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

    override func viewDidLoad() {
        super.viewDidLoad()

        store.fetchfiveDayWeatherForecast(with: "-25.92", and: "28.14") { (weatherResult) in
            switch weatherResult {
            case let .Success(weatherResult):
                print("successfully decoded:\n\(weatherResult.list)")
//                self.cellViewModels = weather.list.map {
//                    AESWeatherCell(weekDay: $0.dt_txt, maximimTemperature: $0.main.maximumTemperature, iconURL: URL(string: "https://openweathermap.org/img/w/\($0.weather[0].icon).png")!)
//                }
//                OperationQueue.main.addOperation {
//                    self.forecastTableView.reloadData()
//                }
                
                //                self.store.fetchWeatherIconForWeather(weather: weather.first!, completion: { (imageResult) in
                //                    switch imageResult {
                //                    case let .Success(image):
                //                        // execute on main queue
                //                        OperationQueue.main.addOperation {
                //                            self.currentWeatherIcon.image = image
                //                        }
                //                    case let .Failure(error):
                //                        print("error downloading image: \(error)")
                //                    }
            //                })
            case let .Failure(error):
                print("Error fetching weather forecast: \(error)")
            }
        }
        
    }
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastWeatherCell", for: indexPath)
        
        return cell
    }

}
