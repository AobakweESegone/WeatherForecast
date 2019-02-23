//
//  Extensions.swift
//  WeatherForecast
//
//  Created by Aobakwe Segone on 2019/02/23.
//  Copyright © 2019 aobakwesegone. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static let sunnyDay = UIColor().colorFromHex(hex: "47AB2F")
    static let cloudyDay = UIColor().colorFromHex(hex: "54717A")
    static let rainyDay = UIColor().colorFromHex(hex: "57575D")
    static let skyBlue = UIColor().colorFromHex(hex: "1282A2")
    
    func colorFromHex(hex: String) -> UIColor {
        // prevention: remove white spaces and uppercase the hex
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // remove hasttags if there's any
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        // default to gray if not a legitimate hex string
        if hexString.count != 6 {
            return UIColor.lightGray
        }
        
        var rgb: uint = 0 // 32 bit interger
        
        ///convert hex strings to our 32 bit interger
        Scanner(string: hexString).scanHexInt32(&rgb)
        
        // break into "red", "green", "blue"
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                            blue: CGFloat(rgb & 0x0000FF) / 255.0,
                            alpha: 1.0)
    }
    
}
