//
//  DailyWeather.swift
//  MyWeatherApp
//
//  Created by fish on 2021/5/16.
//

import Foundation

struct DailyWeather: Codable, Identifiable {
    var dt: Int
    var temp: Temperature
    var weather: [WeatherDetail]
    
    enum CodingKey: String {
        case dt
        case temp
        case weather
    }
    
    init() {
        dt = 0
        temp = Temperature(min: 0.0, max: 0.0)
        weather = [WeatherDetail(main: "", description:"", icon: "")]
    }
    
    static func empty() -> DailyWeather {
//        return DailyWeather(dt:0, temp:Temperature(min: 0.0, max: 0.0),
//                            weather:[WeatherDetail(main: "", description:"", icon: "")])
        return DailyWeather()
    }
}

extension DailyWeather {
    var id: UUID {
        return UUID()
    }
}
