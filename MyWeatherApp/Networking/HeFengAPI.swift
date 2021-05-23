//
//  API.swift
//  MyWeatherApp
//
//  Created by fish on 2021/5/13.
//

import Foundation

struct HeFengAPI {
    static let key = "911cc2dc87a3496da590163cb3f46048"
}

extension HeFengAPI {
    static let liveURLString = "https://devapi.qweather.com/v7/weather/"
    
    static func getLiveURLFor(lat: Double, lon: Double) -> String {
        return "\(liveURLString)now?location=\(lon),\(lat)&key=\(key)"
    }
    
    static func getDailyURLFor(lat: Double, lon: Double) -> String {
        return "\(liveURLString)3d?location=\(lon),\(lat)&key=\(key)"
    }
    
    static func getHistoryURLFor(lat: Double, lon: Double) -> String {
        return "\(liveURLString)location=\(lon),\(lat)&key=\(key)"
    }
}
