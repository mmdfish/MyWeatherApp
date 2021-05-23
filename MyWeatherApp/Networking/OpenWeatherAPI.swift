//
//  OpenWeatherAPI.swift
//  MyWeatherApp
//
//  Created by fish on 2021/5/15.
//

import Foundation

struct OpenWeatherAPI {
    static let key = "84fbc4ebc8e083a944af0ef981013998"
    
    static let baseURLString = "https://api.openweathermap.org/data/2.5/"
        
    static func getCurrentURLFor(lat: Double, lon: Double) -> String {
        return "\(baseURLString)onecall?lat=\(lat)&lon=\(lon)&exclude=minutely&appid=\(key)&units=imperial"
    }
    
    static func getHistoryURLFor(lat: Double, lon: Double, dt: Int) -> String {
        return "\(baseURLString)onecall/timemachine?lat=\(lat)&lon=\(lon)&dt=\(dt)&appid=\(key)"
    }
}
