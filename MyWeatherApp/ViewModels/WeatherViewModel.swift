//
//  WeatherViewModel.swift
//  MyWeatherApp
//
//  Created by fish on 2021/5/17.
//

import Foundation
import CoreLocation

class WeatherViewModel: ObservableObject {
    @Published var isCitySet: Bool = false
    @Published var cityName: String = "City Name"
    @Published var location: CLLocation = CLLocation(latitude: 39.92, longitude: 116.42)
    @Published var weather: WeatherData = WeatherData.empty()
    @Published var yesterdayWeather: DailyWeather = DailyWeather.empty()
    @Published var shouldShowLocationError: Bool = false
    
    public let weatherService: WeatherService
    public let cityService: CityService
    
//    let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
//                      "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"];
    
//    let directions = ["北", "东北偏北", "东北", "东北偏东", "东", "东南偏东", "东南", "东南偏南",
//                      "南", "西南偏南", "西南", "西南偏西", "西", "西北偏西", "西北", "西北偏北"];
    
    let directions = ["北", "东北", "东北", "东北", "东", "东南", "东南", "东南",
                      "南", "西南", "西南", "西南", "西", "西北", "西北", "西北"];

    init(weatherService: WeatherService, cityService: CityService) {
        self.weatherService = weatherService
        self.cityService = cityService
        self.isCitySet = UserDefaults.standard.bool(forKey: "isCitySet")
        if(self.isCitySet) {
            if let name = UserDefaults.standard.string(forKey: "cityName") {
                self.cityName = name
            }
            let latitude = UserDefaults.standard.double(forKey: "latitude")
            let longitude = UserDefaults.standard.double(forKey: "longitude")
            self.location = CLLocation(latitude: latitude, longitude: longitude)
        }
    }
    
    func refresh() {
        if(self.isCitySet) {
            refreshSetCity()
        } else {
            refreshByLocation()
        }
    }
    
    func refreshByLocation() {
        print("Start to refresh by Location")
        weatherService.getLocationData { location, error in
            
            DispatchQueue.main.async {
                if let _ = error {
                    self.shouldShowLocationError = true
                    return
                }

                self.shouldShowLocationError = false
                
                guard let myLocation = location else {return}
                
                self.weatherService.getAdderess(myLocation) { address in
                    
                    DispatchQueue.main.async {
                        guard let myAddress = address else {
                            return
                        }
                        self.cityName = myAddress
                    }
                }
                
                self.weatherService.getWeatherData(myLocation) { weather in
                    DispatchQueue.main.async {
                        guard let myWeather = weather else {
                            return
                        }
                        self.weather = myWeather
                    }
                }

                self.weatherService.getHisWeatherData(myLocation) { weather in
                    DispatchQueue.main.async {
                        guard let myWeather = weather else {
                            return
                        }
                        self.yesterdayWeather = self.weatherService.changeYesterdayWeather(myWeather)
                    }
                }
            }
        }
    }
    
    func setIsCitySet(_ isSet: Bool) {
        self.isCitySet = isSet
        if(isSet == false) {
            self.weatherService.reUpdatingLocation()
        }
        UserDefaults.standard.set(self.isCitySet, forKey: "isCitySet")
    }
    
    func setCity(_ city: String, _ location: CLLocation) {
        self.cityName = city
        self.location = location
        UserDefaults.standard.set(self.cityName, forKey: "cityName")
        UserDefaults.standard.set(self.location.coordinate.latitude, forKey: "latitude")
        UserDefaults.standard.set(self.location.coordinate.longitude, forKey: "longitude")
    }
    
    func refreshSetCity() {
        print("Start to refresh by City")
        self.weatherService.getWeatherData(self.location) { weather in
            DispatchQueue.main.async {
                guard let myWeather = weather else {
                    return
                }
                self.weather = myWeather
            }
        }

        self.weatherService.getHisWeatherData(self.location) { weather in
            DispatchQueue.main.async {
                guard let myWeather = weather else {
                    return
                }
                self.yesterdayWeather = self.weatherService.changeYesterdayWeather(myWeather)
            }
        }
    }
    
    func getTempC(temp: Double, isF: Bool) -> String{
        if(isF) {
            let ctemp = (temp - 32)/1.8
            return String(Int(ctemp))
        } else {
            return String(Int(temp))
        }
    }
    
    func getWindScale(speed: Double) -> Int {
        if(speed <= 0.2 ) {
            return 0
        } else if(speed <= 1.5) {
            return 1
        } else if(speed <= 3.3) {
            return 2
        } else if(speed <= 5.4) {
            return 3
        } else if(speed <= 7.9) {
            return 4
        } else if(speed <= 10.7) {
            return 5
        } else if(speed <= 13.8) {
            return 6
        } else if(speed <= 17.1) {
            return 7
        } else if(speed <= 20.7) {
            return 8
        } else if(speed <= 24.4) {
            return 9
        } else if(speed <= 28.4) {
            return 10
        } else if(speed <= 32.6) {
            return 11
        } else if(speed <= 36.9) {
            return 12
        }
        return 0
    }
    
    func getWindDirection(degrees: Int) -> String {
        let i = Int((Double(degrees) + 11.25)/22.5);
        return directions[i % 16];
    }
    
    private lazy var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd"
        return formatter
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    func getDayFor(timestamp: Int) -> String {
        return dayFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
    
    func getDateFor(timestamp: Int) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
}
