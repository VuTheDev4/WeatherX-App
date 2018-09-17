//
//  WeatherViewController.swift
//  WeatherX
//
//  Created by Vu Duong on 9/11/18.
//  Copyright © 2018 Vu Duong. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "ec1636863a30272c90dcacb70acef71f"

    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        
        updateUIWithWeatherData()
    }
    
    
    
    // HTTP Request
    func getWeatherData(url: String, parameters: [String: String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the weather data")
                
                // JSON Results
                let weatherJSON : JSON = JSON(response.result.value!)
                print(weatherJSON)
                //Parsing
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil

            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID ]
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error)
        cityLabel.text = "Location Unavailable"
        
    }
    
    
    // Parsing JSON
    func updateWeatherData(json: JSON) {
        // Changes JSON to double
        if let tempResult = json["main"]["temp"].double {
            
            weatherDataModel.temperature = Int((tempResult - 273) * 1.8 + 32)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.description = json["weather"][0]["description"].stringValue
            
            print(weatherDataModel.condition)
            
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()
        }
        else {
            temperatureLabel.text = ""
            weatherIcon.image = UIImage(named: "sunny")
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    func updateUIWithWeatherData() {
        temperatureLabel.text = " \(weatherDataModel.temperature)°"
        cityLabel.text = weatherDataModel.city
        weatherIcon.image = UIImage(named: "\(weatherDataModel.weatherIconName)")
        descriptionLabel.text = "\(weatherDataModel.description)"
        
        
    }
    
    func userEnteredNewCityName(city: String) {
        let params : [String: String] = ["q" : city, "appid": APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "changeCitySegue" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
    }
    
}

