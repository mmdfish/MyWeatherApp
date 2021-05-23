//
//  WeatherView.swift
//  MyWeatherApp
//
//  Created by fish on 2021/5/17.
//

import SwiftUI

struct WeatherView: View {

  @ObservedObject var viewModel: WeatherViewModel

  var body: some View {
    VStack {
      Text(viewModel.cityName)
        .font(.largeTitle)
        .padding()
        Text(String(viewModel.weather.current.temp))
        .font(.system(size: 70))
        .bold()
        Text(viewModel.weather.current.weather.description)
        Text(viewModel.yesterdayWeather.weather.description)
    }
    .alert(isPresented: $viewModel.shouldShowLocationError) {
      Alert(
        title: Text("Error"),
        message: Text("To see the weather, provide location access in Settings."),
        dismissButton: .default(Text("Open Settings")) {
          guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
          UIApplication.shared.open(settingsURL)
        }
      )
    }
    .onAppear(perform: viewModel.refresh)
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    WeatherView(viewModel: WeatherViewModel(weatherService: WeatherService()))
  }
}
