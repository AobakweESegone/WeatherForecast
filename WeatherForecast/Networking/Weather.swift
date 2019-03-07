//
//  Weather.swift
//  WeatherForecast
//
//  Created by Aobakwe Segone on 2019/02/07.
//  Copyright © 2019 aobakwesegone. All rights reserved.
//

import Foundation

/*
 * current weather model
 */

struct CurrentWeatherAPI: Decodable {
    let coord: CurrentCoordinates
    let weather: [CurentWeather]
    let main: CurrentMain
    let visibility: Int?
    let wind: CurrentWind
    let clouds: CurrentClouds
    let dt: Int
    let sys: System
}

struct CurrentCoordinates: Decodable {
    let lon: Double
    let lat: Double
}

struct CurentWeather: Decodable {
    let main: String
    let description: String
    let icon: String
}

struct System: Decodable {
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct CurrentMain: Decodable {
    let currentTemperature : Double
    let minimumTemperature: Double?
    let maximumTemperature: Double?
    let pressure: Double
    let humidity: Int
    
    private enum CodingKeys: String, CodingKey {
        case currentTemperature = "temp"
        case minimumTemperature = "temp_min"
        case maximumTemperature = "temp_max"
        case pressure = "pressure"
        case humidity = "humidity"
    }
}

struct CurrentClouds: Decodable {
    let all: Int
}

struct CurrentWind: Decodable {
    let speed: Double?
    let deg: Double?
}
