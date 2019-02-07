//
//  ForecastWeather.swift
//  WeatherForecast
//
//  Created by Aobakwe Segone on 2019/02/07.
//  Copyright © 2019 aobakwesegone. All rights reserved.
//

import Foundation

/*
 * forecast weather model
 */

struct WeatherForecastAPI: Decodable {
    let list: [ForecastHour]
    let city: City
}

struct City: Decodable  {
    let name: String
    let country: String
    let coord: Coordinates
}

struct ForecastHour: Decodable {
    let dt: Int
    let dt_txt: String
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
}

struct Coordinates: Decodable {
    let lat: Double
    let lon: Double
}

struct Main: Decodable {
    let currentTemperature : Double
    let minimumTemperature: Double
    let maximumTemperature: Double
    let pressure: Double
    let seaLevel: Double
    let groundLevel: Double
    let humidity: Int
    
    private enum CodingKeys: String, CodingKey {
        case currentTemperature = "temp"
        case minimumTemperature = "temp_min"
        case maximumTemperature = "temp_max"
        case pressure = "pressure"
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
        case humidity = "humidity"
    }
}

struct Weather: Decodable {
    let main: String
    let description: String
    let icon: String
}

struct Clouds: Decodable {
    let all: Int
}

struct Wind: Decodable {
    let speed: Double
    let deg: Double
}



