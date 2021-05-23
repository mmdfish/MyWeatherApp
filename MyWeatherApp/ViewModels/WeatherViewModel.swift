//
//  WeatherViewModel.swift
//  MyWeatherApp
//
//  Created by fish on 2021/5/17.
//

import Foundation
import CoreLocation

class WeatherViewModel: ObservableObject {
    @Published var cityName: String = "City Name"
    @Published var weather: WeatherData = WeatherData.empty()
    @Published var yesterdayWeather: DailyWeather = DailyWeather.empty()
    @Published var shouldShowLocationError: Bool = false
    
    public let weatherService: WeatherService

    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    func refresh() {
        print("Start to get Location")
        weatherService.getLocationData { location, error in
            
            print("Start to get Location")
            
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
    
    
}
