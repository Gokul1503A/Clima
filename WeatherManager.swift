//
//  WeatherManager.swift
//  Clima
//
//  Created by KOPPOLA GOKUL SAI on 19/12/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol weatherManagerDeligate {
    func didUpdate(_ weatherManager: WeatherManager,weather : WeatherModel)
    func didFailed(_ error: Error)
}

struct WeatherManager {
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=  " //add api id here after =
    
    
    func addCityname(city: String){
        let URLString = "\(baseURL)&q=\(city)"
        performRequest(URLString: URLString)
    }
    
    func fetchWeather(latitude : CLLocationDegrees, longitude: CLLocationDegrees)
    {
        let URLString = "\(baseURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(URLString: URLString)
    }
    
    var deligate : weatherManagerDeligate?
    
    func performRequest(URLString : String){
        guard let url = URL(string: URLString) else { return } // convert string to url
        
        // create url session
        
        let session = URLSession(configuration: .default)
        
        // give seesion task
        
        let task = session.dataTask(with: url){(data, URLResponse, error) in
            if error != nil {
                self.deligate?.didFailed(error!)
                return
            }
            if let safeData = data {
               
                if let weather = parseJSON(weatherData: safeData){
                    self.deligate?.didUpdate(self, weather: weather)
                }
            }
        }
        // start task
        
        task.resume()
    }
    
    
    func parseJSON (weatherData : Data) -> WeatherModel?{
        
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherDataStruct.self, from: weatherData)
           
            let name = decodedData.name
            
            let id = decodedData.weather[0].id
            
            let temparature = decodedData.main.temp
            
            let weather = WeatherModel(CityName: name, Temperature: temparature, ConditionId: id)
            print(weather.ConditionName)
            print(weather.temperatureString)
            return weather
        }
        catch{
            deligate?.didFailed(error)
            return nil
        }
    }
    
    
}
