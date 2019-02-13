//
//  AppDelegate.swift
//  WeatherForecast
//
//  Created by Aobakwe Segone on 2019/02/05.
//  Copyright © 2019 aobakwesegone. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let rootViewController = window!.rootViewController as! WeatherForecastViewController
        let weatherForecastViewController = rootViewController
        weatherForecastViewController.store = WeatherStore()
        let weatherStore = WeatherStore()
        
        weatherStore.fetchCurrentWeather(with: "-25.96", and: "28.14") { (weatherResult) in
            switch weatherResult {
            case let .Success(weather):
                
                let currentWeatherDictionary = ["currentWeather": weather]
                
                OperationQueue.main.addOperation {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Current Weather Available"), object: nil, userInfo: currentWeatherDictionary)
                }
            case .Failure(_): break
            }
        }
        
        weatherStore.fetchfiveDayWeatherForecast(with: "-25.96", and: "28.14") { (weatherResult) in
            switch weatherResult {
            case let .Success(weather):
                
                let weatherForecastDictionary = ["forecastWeather": weather]
                
                OperationQueue.main.addOperation {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ForecastWeather Available"), object: nil, userInfo: weatherForecastDictionary)
                }
            case .Failure(_): break
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

