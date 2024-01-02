//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var weather = WeatherManager()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
       
        
        searchTextField.delegate = self
        weather.deligate = self 
    }

    @IBAction func locationButton(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
    
}

// MARK: - textfieldDeligate Extension


extension WeatherViewController : UITextFieldDelegate {
    @IBAction func searchButton(_ sender: UIButton) {
        searchTextField.endEditing(true)
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)

        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        }
        else{
            searchTextField.placeholder = "Search"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let safeoptional = searchTextField.text{
            print(safeoptional)
            weather.addCityname(city: safeoptional)
        }
        searchTextField.text = ""
    }
}
// MARK: - weathermanager deligate

extension WeatherViewController: weatherManagerDeligate {
    
    func didUpdate(_ weatherManager: WeatherManager, weather: WeatherModel) {
        print(weather.Temperature)
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.CityName
            self.conditionImageView.image = UIImage(systemName: weather.ConditionName)
        }
        
   
        
        
    }
    
    func didFailed(_ error: Error) {
        print(error)
    }
    
}
// MARK: - CLLocationdeligate

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("got location")
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            
            weather.fetchWeather(latitude: lat, longitude: long)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
