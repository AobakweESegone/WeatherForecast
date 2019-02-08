//
//  OpenWeatherMapAPI.swift
//  WeatherForecast
//
//  Created by Aobakwe Segone on 2019/02/07.
//  Copyright © 2019 aobakwesegone. All rights reserved.
//

import Foundation

enum EndPoint: String {
    case CurrentWeather = "api.openweathermap.org/data/2.5/weather"
    case fiveDayWeatherForecast = "api.openweathermap.org/data/2.5/forecast"
}

enum WeatherResult {
    case Success(WeatherForecastAPI)
    case Failure(WeatherAPIError)
}

enum WeatherAPIError: Error {
    case apiError
    case badResponse
    case InvalidJSONData // an error during the parsing of the json response
    case unknown(String) // some unknown error
}

struct AESOpenWeatherMapAPI {
    
    // parameter common to all requests
    private static let APIKey = "b57490d6932dc34c9ca0b1a6684fb571";
    private static let units = "metric";
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter
    }()
    
    private static func openWeatherMapURL(for endPoint: EndPoint, latitude: String, longitude: String, andParameters:[String:String]?) -> URL {
        
        let urlComponents = NSURLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = endPoint.rawValue
        
        var queryItems = [NSURLQueryItem]()
        
        // common query items to all requests
        let baseParams = [
            "lat": latitude,
            "lon": longitude,
            "APPID": APIKey,
            "units": units
        ]
        
        for (key, value) in baseParams {
            let anItem = NSURLQueryItem(name: key, value: value)
            queryItems.append(anItem)
        }
        
        if let parameters = andParameters {
            for (key,value) in parameters {
                let anItem = NSURLQueryItem(name: key, value: value)
                // add to queryItems array
                queryItems.append(anItem)
            }
        }
        
        urlComponents.queryItems = queryItems as [URLQueryItem]
        
        let url = urlComponents.url! as URL
        let urlString = url.absoluteString.removingPercentEncoding
        
        return URL(string: urlString!)!
    }
    
    static func currentWeatherURL(for latitude: String, and longitude: String) -> URL {
        return openWeatherMapURL(for: .CurrentWeather, latitude: latitude, longitude: longitude, andParameters: nil)
    }
    
    static func fiveDayWeatherForecastURL(for latitude: String, and longitude: String) -> URL {
        return openWeatherMapURL(for: .fiveDayWeatherForecast, latitude: latitude, longitude: longitude, andParameters: nil)
    }
    
    // serialize the incoming data to foundation objects
    static func weatherFromJSONData(data: Data) -> WeatherResult {
        do {
            let weatherForecast = try JSONDecoder().decode(WeatherForecastAPI.self, from: data)
            return .Success(weatherForecast)
        }
        catch let error {
            return .Failure(.unknown(error.localizedDescription))
        }
    }
    
    static func weatherFromModelledObject(modelledObject: ForecastHour) -> FiveDayForecastWeather? {
        let forecastHour = modelledObject
        
        let dateTaken = forecastHour.dt_txt
        
        let currentTemperature = forecastHour.main.currentTemperature
        let minimumTemperature = forecastHour.main.minimumTemperature
        let maximumTemperature = forecastHour.main.maximumTemperature
        
        // weather has only one item in it
        let weather = forecastHour.weather[0]
        let weatherCondition = weather.main
        let weatherDescription = weather.description
        let weatherConditionIconURL = URL(string: "https://openweathermap.org/img/w/\(weather.icon).png")
        
        return FiveDayForecastWeather(weatherCondition: weatherCondition, weatherConditionDescription: weatherDescription, weatherConditionIconURL: weatherConditionIconURL!, currentTemperature: currentTemperature, minimumTemperature: minimumTemperature, maximumTemperature: maximumTemperature, dateTaken: dateFormatter.date(from: dateTaken)!) as FiveDayForecastWeather
        
    }
    
}

