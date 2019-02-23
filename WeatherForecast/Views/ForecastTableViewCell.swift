//
//  ForecastTableViewCell.swift
//  WeatherForecast
//
//  Created by Aobakwe Segone on 2019/02/08.
//  Copyright © 2019 aobakwesegone. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var conditionIcon: UIImageView!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var forecastConditionDescription: UILabel!
    
    var iconURL: URL!
    
    // MARK:- view life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK:- view methods
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        guard let imageData = try? Data(contentsOf: iconURL) else {
            return
        }
        
        let image = UIImage(data: imageData)
        OperationQueue.main.addOperation {
            completion(image)
        }
    }
}

