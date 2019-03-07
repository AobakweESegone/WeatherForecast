//
//  ImageExtension.swift
//  WeatherForecast
//
//  Created by Aobakwe Segone on 2019/03/07.
//  Copyright © 2019 aobakwesegone. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    static let sunnyDay = UIImage().backgroundImageFrom(weatherGroup: "sunny")
    static let rainyDay = UIImage().backgroundImageFrom(weatherGroup: "rain")
    static let cloudyDay = UIImage().backgroundImageFrom(weatherGroup: "clouds")
    
    func backgroundImageFrom(weatherGroup group: String) -> UIImage {
        return UIImage(named: group)!
    }
}
