//
//  WeatherDetail.swift
//  MyWeatherApp
//
//  Created by fish on 2021/5/16.
//

import Foundation

struct WeatherDetail: Codable {
    var main: String
    var description: String
    var icon: String
    
    init() {
        main =  "晴"
        description = "light rain"
        icon = "10d"
    }
}
