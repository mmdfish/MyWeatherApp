//
//  City.swift
//  MyWeatherApp
//
//  Created by fish on 2021/6/14.
//

import Foundation

class PopCity {
    var city: String
    var adcode: String
    var longitude: Double
    var latitude: Double
    var isSetCity: Bool
    
    init() {
        city = "北京"
        adcode = "110000"
        longitude = 116.407526
        latitude = 39.90403
        isSetCity = true
    }
}

struct CityDetail {
    var adcode: String
    var longitude: Double
    var latitude: Double
    var province: String
    var city: String
    var district: String
    var address: String
    
    init() {
        adcode = "adcode"
        longitude = 116.407526
        latitude = 39.90403
        province = "北京市"
        city = "北京市"
        district = ""
        address = "北京市"
    }
}
