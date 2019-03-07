//
//  WeatherForecastViewController.swift
//  WeatherForecast
//
//  Created by Aobakwe Segone on 2019/02/05.
//  Copyright © 2019 aobakwesegone. All rights reserved.
//

import UIKit
import CoreLocation

enum DaysOfTheWeek: Int {
    case Sunday = 1, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
}

class WeatherForecastViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    var store: WeatherStore!
    var cellViewModels = [ForecastWeatherCell]()
    
    let locationManager = CLLocationManager()
    var didFindLocation: Bool?
    
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    
    @IBOutlet weak var conditionDescriptionLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    
    @IBOutlet weak var forecastTableView: UITableView!
    
    var currentWeatherDictionary: CurrentWeatherAPI?
    var weatherForecastDictionary: WeatherForecastAPI?
    
    let dispatchGroup = DispatchGroup()
    
    // MARK:- view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.forecastTableView.rowHeight = 90
        
        self.generateCurrentLocationCoordinates()
    }
    
    // MARK:- methods
    
    @objc func receivedForecastWeather(notification: Notification) {
        if notification.name.rawValue == "ForecastWeather Available" {
            let forecastWeatherList: WeatherForecastAPI = notification.userInfo!["forecastWeather"] as! WeatherForecastAPI
            
            // retrieve the 5 day forecast from the posted weather forecast dictionary
            let fiveDayForecast: [ForecastHour] = computeFiveDayForecast(from: forecastWeatherList.list)
            
            // fetch weather icons for a 5 day forecast and display data
            self.cellViewModels = fiveDayForecast.map {
                ForecastWeatherCell(weekDay: $0.dt_txt, minimumTemperature: $0.main.minimumTemperature != nil ? $0.main.minimumTemperature! : 0.0, maximumTemperature: $0.main.maximumTemperature != nil ? $0.main.maximumTemperature! : 0.0, iconURL: URL(string: "https://openweathermap.org/img/w/\($0.weather[0].icon).png")!, forecastConditionDescription: $0.weather[0].description)
            }
            
            OperationQueue.main.addOperation {
                self.forecastTableView.reloadData()
            }
            
            currentLocation.text = "\(forecastWeatherList.city.name)\n\(forecastWeatherList.city.country)"
        }
    }
    
    @objc func receivedCurrentWeather(notification: Notification) {
        if notification.name.rawValue == "Current Weather Available" {
            let currentWeather: CurrentWeatherAPI = notification.userInfo!["currentWeather"] as! CurrentWeatherAPI
            
            self.currentTempLabel.text = "\(Int(currentWeather.main.currentTemperature.rounded(.toNearestOrAwayFromZero)))\u{00B0}"
            self.minTemperatureLabel.text = currentWeather.main.minimumTemperature != nil ? "\(Int(currentWeather.main.minimumTemperature!.rounded(.toNearestOrAwayFromZero)))\u{00B0}" : ""
            self.maxTemperatureLabel.text = currentWeather.main.maximumTemperature != nil ? "\(Int(currentWeather.main.maximumTemperature!.rounded(.toNearestOrAwayFromZero)))\u{00B0}" : ""
            self.conditionDescriptionLabel.text = "\(currentWeather.weather[0].description)"
            
            let weatherGroup = "\(currentWeather.weather[0].main)".lowercased()
            if weatherGroup.contains("clear") {
                self.backgroundImageView.image = UIImage.sunnyDay
                self.view.backgroundColor = UIColor.sunnyDay
            } else if weatherGroup.contains("clouds") {
                self.backgroundImageView.image = UIImage.cloudyDay
                self.view.backgroundColor = UIColor.cloudyDay
            } else if weatherGroup.contains("rain") {
                self.backgroundImageView.image = UIImage.rainyDay
                self.view.backgroundColor = UIColor.rainyDay
            } else {
                self.view.backgroundColor = UIColor.skyBlue
            }
            
            /*
             
             current weather icon excluded
             
             guard let imageData = try? Data(contentsOf: URL(string: "https://openweathermap.org/img/w/\(currentWeather.weather[0].icon).png")!) else {
             return
             }
             let image = UIImage(data: imageData)
             OperationQueue.main.addOperation {
             self.currentWeatherIcon.image = image!
             }*/
            
        }
    }
    
    func updateInterface(withCurrentWeatherDictionary currentWeather: CurrentWeatherAPI, andForecastWeatherDictionary forecastWeather: WeatherForecastAPI) {
        dispatchGroup.enter()
        
        let currentWeather = currentWeather
        
        self.currentTempLabel.text = "\(Int(currentWeather.main.currentTemperature.rounded(.toNearestOrAwayFromZero)))\u{00B0}"
        self.minTemperatureLabel.text = currentWeather.main.minimumTemperature != nil ? "\(Int(currentWeather.main.minimumTemperature!.rounded(.toNearestOrAwayFromZero)))\u{00B0}" : ""
        self.maxTemperatureLabel.text = currentWeather.main.maximumTemperature != nil ? "\(Int(currentWeather.main.maximumTemperature!.rounded(.toNearestOrAwayFromZero)))\u{00B0}" : ""
        self.conditionDescriptionLabel.text = "\(currentWeather.weather[0].description)"
        
        let weatherGroup = "\(currentWeather.weather[0].main)".lowercased()
        if weatherGroup.contains("clear") {
            self.backgroundImageView.image = UIImage.sunnyDay
            self.view.backgroundColor = UIColor.sunnyDay
        } else if weatherGroup.contains("clouds") {
            self.backgroundImageView.image = UIImage.cloudyDay
            self.view.backgroundColor = UIColor.cloudyDay
        } else if weatherGroup.contains("rain") {
            self.backgroundImageView.image = UIImage.rainyDay
            self.view.backgroundColor = UIColor.rainyDay
        } else {
            self.view.backgroundColor = UIColor.skyBlue
        }
        
        let forecastWeatherList = forecastWeather
        
        // retrieve the 5 day forecast from the posted weather forecast dictionary
        let fiveDayForecast: [ForecastHour] = computeFiveDayForecast(from: forecastWeatherList.list)
        
        // fetch weather icons for a 5 day forecast and display data
        self.cellViewModels = fiveDayForecast.map {
            ForecastWeatherCell(weekDay: $0.dt_txt, minimumTemperature: $0.main.minimumTemperature != nil ? $0.main.minimumTemperature! : 0.0, maximumTemperature: $0.main.maximumTemperature != nil ? $0.main.maximumTemperature! : 0.0, iconURL: URL(string: "https://openweathermap.org/img/w/\($0.weather[0].icon).png")!, forecastConditionDescription: $0.weather[0].description)
        }
        
        currentLocation.text = "\(forecastWeatherList.city.name)\n\(forecastWeatherList.city.country)"
        
        dispatchGroup.leave()
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
    
    func generateCurrentLocationCoordinates() {
        self.didFindLocation = false
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters  // not best for preventing too much power consumption
        locationManager.distanceFilter = 100.0 // location services every 100m
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.requestLocation()
    }
    
    // MARK:-  UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        dispatchGroup.enter()
        
        let weatherCell = cellViewModels[indexPath.row]
        
        let cell: ForecastTableViewCell = tableView.dequeueReusableCell(withIdentifier: "forecastWeatherCell", for: indexPath) as! ForecastTableViewCell
        
        weatherCell.loadWeatherIcon(completion: { (image) in
            cell.conditionIcon.image = image
            
            self.dispatchGroup.leave()
        })
        
        let today = ", today"
        if indexPath.row == 0 {
            cell.weekDayLabel.text = "\(formatDate(dateString: weatherCell.weekDay))" + today
        } else {
            cell.weekDayLabel.text = "\(formatDate(dateString: weatherCell.weekDay))"
        }
        
        cell.minTemperatureLabel.text = "\(Int(weatherCell.minimumTemperature.rounded(.toNearestOrAwayFromZero)))\u{00B0}"
        cell.maxTemperatureLabel.text = "\(Int(weatherCell.maximumTemperature.rounded(.toNearestOrAwayFromZero)))\u{00B0}"
        cell.forecastConditionDescription.text = weatherCell.forecastConditionDescription
        
        return cell
    }
    
    // MARK:- location manager delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lat = locations.last?.coordinate.latitude, let long = locations.last?.coordinate.longitude {
            
            if didFindLocation != true {
                didFindLocation = true
                
                print("location obtained: \(lat),\(long)")
                
                let latString = String(format: "%f", lat)
                let longString = String(format: "%f", long)
                
                store.fetchCurrentWeather(with: latString, and: longString) { (weatherResult) in
                    switch weatherResult {
                    case let .Success(weather):
                        
                        self.currentWeatherDictionary = weather
                    case .Failure(_): break
                    }
                }
                
                store.fetchfiveDayWeatherForecast(with: latString, and: longString) { (weatherResult) in
                    switch weatherResult {
                    case let .Success(weather):
                        
                        self.weatherForecastDictionary = weather
                        
                        self.store.dispatchGroup.notify(queue: .main) {
                            self.dispatchGroup.enter()
                            
                            self.updateInterface(withCurrentWeatherDictionary: self.currentWeatherDictionary!, andForecastWeatherDictionary: self.weatherForecastDictionary!)
                            self.forecastTableView.reloadData()
                        }
                        
                    case .Failure(_): break
                    }
                }
            }
            
        } else {
            print("No coordinates")
            
            let alert = UIAlertController(title: "Location Data", message: "Location coordinates for your position could not be obtained.", preferredStyle: .alert)
            let OK = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
            alert.addAction(OK)
            self.present(alert, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("encounted error: ", error.localizedDescription)
        
        let alert = UIAlertController(title: "Location Information", message: "Failed to obtain location information.", preferredStyle: .alert)
        let OK = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        alert.addAction(OK)
        self.present(alert, animated: true)
        
        //self.activityIndicator.stopAnimating()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .notDetermined, .restricted:
            let alert = UIAlertController(title: "Location Services Disabled", message: "To get your weather information, please enable Location Services.", preferredStyle: .alert)
            
            let cancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            
            let open = UIAlertAction.init(title: "Open Settings", style: .default, handler: { (_) in
                if let url = NSURL(string:UIApplication.openSettingsURLString) {
                    UIApplication.shared.openURL(url as URL)
                }
            })
            
            alert.addAction(open)
            self.present(alert, animated: true)
        default:
            break
            
        }
    }
    
}
