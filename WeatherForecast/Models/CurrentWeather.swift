//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Aobakwe Segone on 2019/02/13.
//  Copyright © 2019 aobakwesegone. All rights reserved.
//

import UIKit

class CurrentWeather: NSObject {
    
    var weatherConditionName: String
    var weatherConditionDiscription: String
    var weatherConditionIcon: String
    
    
    // MARK: - initializer
    
    init(weatherConditionName: String, weatherConditionDiscription: String, weatherConditionIcon: String) {
        
        self.weatherConditionName = weatherConditionName;
        self.weatherConditionDiscription = weatherConditionDiscription;
        self.weatherConditionIcon = weatherConditionIcon;
        
        super.init();
        
    }
    
}
