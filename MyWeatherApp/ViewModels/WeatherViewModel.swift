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

    init(weatherService: WeatherService) {
        self.weatherService = weatherService
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
    
}
