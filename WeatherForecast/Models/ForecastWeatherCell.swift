//
//  ForecastWeatherCell.swift
//  WeatherForecast
//
//  Created by Aobakwe Segone on 2019/02/08.
//  Copyright © 2019 aobakwesegone. All rights reserved.
//

import UIKit

struct ForecastWeatherCell {
    
    let weekDay: String
    let minimumTemperature: Double
    let maximumTemperature: Double
    let iconURL: URL
    
    func loadWeatherIcon(completion: @escaping (UIImage) -> Void) {
        guard let imageData = try? Data(contentsOf: iconURL) else {
            return
        }
        
        let image = UIImage(data: imageData)
        OperationQueue.main.addOperation {
            completion(image!)
        }
    }
    
}

