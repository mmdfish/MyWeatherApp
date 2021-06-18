//
//  CityService.swift
//  MyWeatherApp
//
//  Created by fish on 2021/6/14.
//

import Foundation

public final class CityService: NSObject {
    private var popCities : [PopCity]?
    private var cities: [CityDetail]?
    
    func getPopCities() -> [PopCity]? {
        if popCities == nil {
            popCities = _getPopCities()
        }
        return popCities
    }
    
    func getTextFileStr(filename:String!) -> String? {
        if let path = Bundle.main.path(forResource: filename, ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                return data
            } catch {
                print(error)
            }
        }
        return ""
    }

    func _getPopCities() -> [PopCity] {
        let filename = "popcity"
        var popcities = [PopCity]()
        let popCity = PopCity()
        popCity.city = "定位"
        popCity.adcode = "000000"
        popCity.isSetCity = false
        popCity.latitude = 0
        popCity.longitude = 0

        popcities.append(popCity)
        
        if let content = getTextFileStr(filename: filename) {
            let lineItems = content.split(separator: "\n")
            for item in lineItems {
                guard let popCity = getPopCity(content: String(item)) else {
                    continue
                }
                popcities.append(popCity)
            }
            return popcities
        }
//        let arr:[String.SubSequence]? = content?.split{ [  Character("\n"),   Character("\r"),  Character("\r\n")].contains($0) }
        return popcities
    }

    func getPopCity(content: String) -> PopCity? {
        let items = content.split(separator: ",")
        if items.count != 4 {
            return nil
        }
        let popCity = PopCity()
        popCity.city = String(items[0])
        popCity.adcode = String(items[1])
        guard let v = Double(String(items[2]))  else {
            return nil
        }
        popCity.longitude = v
        guard let v1 = Double(String(items[3]))  else {
            return nil
        }
        popCity.latitude = v1
        return popCity
    }
}
