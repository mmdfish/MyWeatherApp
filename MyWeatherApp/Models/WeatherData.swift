//
//  File.swift
//  MyWeatherApp
//
//  Created by fish on 2021/5/16.
//

import Foundation

struct WeatherData: Codable {
    var current: Weather
    var daily: [DailyWeather]
    
    static func empty() -> WeatherData {
        return WeatherData(current: Weather(), daily: [DailyWeather](repeating: DailyWeather(), count: 7))
    }
}

struct HistoryWeatherData: Codable {
    var hourly: [Weather]
    
    static func empty() -> HistoryWeatherData {
        return HistoryWeatherData(hourly: [Weather](repeating: Weather(), count: 24))
    }
}
