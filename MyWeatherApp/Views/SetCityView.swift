//
//  SetCityView.swift
//  MyWeatherApp
//
//  Created by fish on 2021/5/30.
//

import SwiftUI
import CoreLocation

struct SetCityView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            let popCities = self.viewModel.cityService.getPopCities()
            let column = 3
            let row = popCities!.count / 3
            
            GridStack(rows: row, columns: column) { row, col in
                let popCity = popCities![row*3 + col]
                Button(action: {
                    self.viewModel.setIsCitySet(popCity.isSetCity)
                    self.viewModel.setCity(popCity.city, CLLocation(latitude: popCity.latitude, longitude: popCity.longitude))
                    self.viewModel.refresh()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text(popCity.city)
                        .font(.system(size: 15)).foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
//                        .padding()
                        .frame(width: 112.0, height: 34.0)
                        .background(RoundedRectangle(cornerRadius: 18)
                        .stroke(Color(red: 0.93, green: 0.93, blue: 0.93),lineWidth: 1)
                        
                        )
                }
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct SetCityView_Previews: PreviewProvider {
    static var previews: some View {
        SetCityView(viewModel: WeatherViewModel(weatherService: WeatherService(), cityService: CityService()))
    }
}
