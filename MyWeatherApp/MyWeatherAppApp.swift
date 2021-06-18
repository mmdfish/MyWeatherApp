//
//  MyWeatherAppApp.swift
//  MyWeatherApp
//
//  Created by fish on 2021/5/12.
//

import SwiftUI

@main
struct MyWeatherAppApp: App {
    var body: some Scene {
        WindowGroup {
            let weatherService = WeatherService()
            let cityService = CityService()
            WeatherView(viewModel: WeatherViewModel(weatherService: weatherService, cityService: cityService))
        }
    }
}
