//
//  FiveDayForecastWeather.swift
//  WeatherForecast
//
//  Created by Aobakwe Segone on 2019/02/07.
//  Copyright © 2019 aobakwesegone. All rights reserved.
//

import UIKit

class FiveDayForecastWeather: NSObject {
    
    var weatherCondition: String
    var weatherConditionDescription: String
    var weatherConditionIconURL: URL
    var currentTemperature: Double
    var minimumTemperature: Double
    var maximumTemperature: Double
    var dateTaken: Date
    
    var iconImage: UIImage?
    
    
    // MARK: - initializer
    
    init(weatherCondition: String, weatherConditionDescription: String, weatherConditionIconURL: URL, currentTemperature: Double, minimumTemperature: Double, maximumTemperature: Double, dateTaken: Date) {
        
        self.weatherCondition = weatherCondition
        self.weatherConditionDescription = weatherConditionDescription
        self.weatherConditionIconURL = weatherConditionIconURL
        self.currentTemperature = currentTemperature
        self.minimumTemperature = minimumTemperature
        self.maximumTemperature = maximumTemperature
        self.dateTaken = dateTaken
        
        super.init();
        
    }
    
}

