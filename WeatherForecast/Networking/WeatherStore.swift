//
//  WeatherStore.swift
//  WeatherForecast
//
//  Created by Aobakwe Segone on 2019/02/07.
//  Copyright © 2019 aobakwesegone. All rights reserved.
//

import UIKit

enum ImageResult {
    case Success(UIImage)
    case Failure(Error)
}

enum IconError: Error {
    case IconCreationError
}

class WeatherStore {
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        //config.waitsForConnectivity = true
        return URLSession(configuration: config)
    }()
    
    let dispatchGroup = DispatchGroup()
    
    func fetchCurrentWeather(with latitude: String, and longitude: String, completion: @escaping (CurrentWeatherResult) -> Void) {
        dispatchGroup.enter()
        
        let currentWeatherURL = AESOpenWeatherMapAPI.currentWeatherURL(for: latitude, and: longitude)
        //let request = URLRequest(url: currentWeatherURL )
        let task = session.dataTask(with: currentWeatherURL) {
            (weatherData, response, error) in
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                completion(.Failure(.badResponse))
                return
            }
            
            guard error == nil else {
                completion(.Failure(.unknown(error!.localizedDescription)))
                return
            }
            
            //            guard let stringWithData = NSString(data: weatherData!, encoding: String.Encoding.utf8.rawValue) as String? else {
            //                completion(.Failure(.apiError))
            //                return
            //            }
            //
            //            let dataFromString = stringWithData.data(using: String.Encoding.utf8)
            //            let data = NSData(data: dataFromString!)
            
            // serialize to model objects
            let result = AESOpenWeatherMapAPI.currentWeatherFromJSONData(data: weatherData! as Data)
            completion(result)
            
            self.dispatchGroup.leave()
        }
        task.resume()
    }
    
    func fetchfiveDayWeatherForecast(with latitude: String, and longitude: String, completion: @escaping (WeatherResult) -> Void) {
        dispatchGroup.enter()
        
        let fiveDayWeatherURL = AESOpenWeatherMapAPI.fiveDayWeatherForecastURL(for: latitude, and: longitude)
        //let request = URLRequest(url: fiveDayWeatherURL as URL)
        let task = session.dataTask(with: fiveDayWeatherURL) {
            (weatherData, response, error) in
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                completion(.Failure(.badResponse))
                return
            }
            
            guard error == nil else {
                completion(.Failure(.unknown(error!.localizedDescription)))
                return
            }
            
            //            guard let stringWithData = NSString(data: weatherData!, encoding: String.Encoding.utf8.rawValue) as String? else {
            //                completion(.Failure(.apiError))
            //                return
            //            }
            //
            //            let dataFromString = stringWithData.data(using: String.Encoding.utf8)
            //            let data = NSData(data: dataFromString!)
            
            // serialize to model objects
            let result = AESOpenWeatherMapAPI.forecastWeatherFromJSONData(data: weatherData! as Data)
            completion(result)
            
            self.dispatchGroup.leave()
        }
        task.resume()
    }
    
    func fetchWeatherIconForWeather(weather: FiveDayForecastWeather, completion: @escaping (ImageResult) -> Void) {
        let iconURL = weather.weatherConditionIconURL
        let request = URLRequest(url: iconURL)
        let task = session.dataTask(with: request) {
            (imageData, response, error) in
            let dataImage = NSData(data: imageData!)
            
            let result = self.processImageRequest(data: dataImage as Data, error: error)
            
            if case let ImageResult.Success(image) = result {
                weather.iconImage = image
            }
            
            completion(result)
        }
        task.resume()
    }
    
    func processImageRequest(data: Data, error: Error?) -> ImageResult {
        let imageData = data
        
        if let image = UIImage(data: imageData as Data) {
            return .Success(image)
        } else {
            return .Failure(IconError.IconCreationError)
        }
    }
    
}
