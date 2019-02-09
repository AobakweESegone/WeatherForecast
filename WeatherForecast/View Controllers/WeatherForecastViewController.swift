//
//  WeatherForecastViewController.swift
//  WeatherForecast
//
//  Created by Aobakwe Segone on 2019/02/05.
//  Copyright © 2019 aobakwesegone. All rights reserved.
//

import UIKit

enum DaysOfTheWeek: Int {
    case Sunday = 1, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
}

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
    
    // MARK:- view life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(receivedForecastWeather), name: NSNotification.Name(rawValue: "ForecastWeather Available"), object: nil)
    }
    
    // MARKS:- methods
    
    @objc func receivedForecastWeather(notification: Notification) {
        if notification.name.rawValue == "ForecastWeather Available" {
            let forecastWeatherList: WeatherForecastAPI = notification.userInfo!["forecastWeather"] as! WeatherForecastAPI
            
            // retrieve the 5 day forecast from the posted weather forecast dictionary
            let fiveDayForecast: [ForecastHour] = computeFiveDayForecast(from: forecastWeatherList.list)
            
            // fetch weather icons for a 5 day forecast and display data
            self.cellViewModels = fiveDayForecast.map {
                ForecastWeatherCell(weekDay: $0.dt_txt, minimumTemperature: $0.main.minimumTemperature, maximumTemperature: $0.main.maximumTemperature, iconURL: URL(string: "https://openweathermap.org/img/w/\($0.weather[0].icon).png")!)
            }
            
            OperationQueue.main.addOperation {
                self.forecastTableView.reloadData()
            }
            
            currentLocation.text = "\(forecastWeatherList.city.name)\n\(forecastWeatherList.city.country)"
        }
    }
    
    /*
     * computeFiveDayForecast(from:) computes the next 5 days weather
    */
    
    func computeFiveDayForecast(from weatherForecastList:[ForecastHour]) -> [ForecastHour] {
        var dateTimes: [Int] = [] // an array of date times
        var fiveDayForecast: [ForecastHour] = [] // an array to of ForecastHour objects
        
        // use ForecastHour's firstObject's DateTime to get the next days
        var dateTimeInSecondsIncrement = weatherForecastList.first!.dt
        
        // generate date times
        for _ in 0...4 {
            // add first day
            dateTimes.append(dateTimeInSecondsIncrement)
            // find next DateTime
            dateTimeInSecondsIncrement += 86400 // increment by 24 hours
        }
        
        // generate five day weather forecast
        for forecastDictionary in weatherForecastList {
            for dateTime in dateTimes {
                if forecastDictionary.dt == dateTime {
                    // date time found, so add the associated weather dictionary
                    fiveDayForecast.append(forecastDictionary)
                }
            }
        }
        
        return fiveDayForecast
    }
    
    func formatDate(dateString: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = dateFormatter.date(from: dateString) else { return "" }
        
        let calendar = Calendar(identifier: .gregorian)
        let weekDay = calendar.component(.weekday, from: date)
        
        var dayName: String = ""
        
        if let dayOfWeek = DaysOfTheWeek(rawValue: weekDay) {
            print("day of week = \(dayOfWeek)")
            switch dayOfWeek {
            case .Monday:
                dayName = "Monday"
            case .Tuesday:
                dayName = "Tuesday"
            case .Wednesday:
                dayName = "Wednesday"
            case .Thursday:
                dayName = "Thursday"
            case .Friday:
                dayName = "Friday"
            case .Saturday:
                dayName = "Saturday"
            case .Sunday:
                dayName = "Sunday"
            }
        }
        
        return dayName
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
        
        let today = ", today"
        if indexPath.row == 0 {
            cell.weekDayLabel.text = "\(formatDate(dateString: weatherCell.weekDay))" + today
        } else {
            cell.weekDayLabel.text = "\(formatDate(dateString: weatherCell.weekDay))"
        }
        
        cell.minTemperatureLabel.text = "\(Int(weatherCell.minimumTemperature.rounded(.toNearestOrAwayFromZero)))\u{00B0}"
        cell.maxTemperatureLabel.text = "\(Int(weatherCell.maximumTemperature.rounded(.toNearestOrAwayFromZero)))\u{00B0}"
        
        return cell
    }

}
