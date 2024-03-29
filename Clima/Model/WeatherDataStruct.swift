//
//  WeatherDataStruct.swift
//  Clima
//
//  Created by KOPPOLA GOKUL SAI on 20/12/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherDataStruct: Decodable {
    let name : String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable{
    let description: String
    let id: Int
}
