//
//  WeatherForecastViewController.swift
//  WeatherForecast
//
//  Created by Aobakwe Segone on 2019/02/05.
//  Copyright © 2019 aobakwesegone. All rights reserved.
//

import UIKit

class WeatherForecastViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastWeatherCell", for: indexPath)
        
        return cell
    }

}
