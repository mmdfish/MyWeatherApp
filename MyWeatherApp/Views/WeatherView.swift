//
//  WeatherView.swift
//  MyWeatherApp
//
//  Created by fish on 2021/5/17.
//

import SwiftUI

struct WeatherView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    @State var presetnKey = false
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        VStack(spacing:0, content: {
            Rectangle()
                .frame(height: 60.0).opacity(0)
            ZStack {
                Text(viewModel.cityName)
                    .font(.system(size: 20))
                HStack {
                    Spacer()
                    Button(
                        action: {
                            self.presetnKey.toggle()
                        },
                        label: {
                            Text("+").font(.system(size: 40)).foregroundColor(Color.gray)
                        }
                    ).padding(.trailing, 20)
                }
            }
            Rectangle()
                .frame(height: 72.0).opacity(0)
            HStack {
                Text("°")
                    .font(.system(size: 90))
                    .bold().opacity(0)
                Text(viewModel.getTempC(temp: viewModel.weather.current.temp, isF: true))
                    .font(.custom("Dosis-Medium-3", size: 90))
                    .bold()
                Text("°")
                    .font(.system(size: 90))
                    .bold()
            }
            Rectangle()
                .frame(height: 28.0).opacity(0)
            Text(String(viewModel.weather.current.weather[0].main))
                .font(.custom("NotoSansSC-Regular", size: 20))
            HStack {
                Text(viewModel.getTempC(temp: viewModel.weather.daily[0].temp.min, isF: true))
                    .font(.custom("NotoSansSC-Regular", size: 20)).foregroundColor(
                        Color(red: 0.51, green: 0.51, blue: 0.51))
                Text("  /  " + viewModel.getTempC(temp: viewModel.weather.daily[0].temp.max, isF: true))
                    .font(.custom("NotoSansSC-Regular", size: 20))
            }
            
            Text(String(
                    viewModel.getWindDirection(degrees: viewModel.weather.current.wind_deg)
                        + "风    " +
                        String(viewModel.getWindScale(speed : viewModel.weather.current.wind_speed))
                        + "级"
            ))
                .font(.custom("NotoSansSC-Regular", size: 20))
            Rectangle().opacity(0)
            
            VStack {
                
                dailyCell(index: -1, weather: viewModel.yesterdayWeather)
                dailyCell(index: 0, weather: viewModel.weather.daily[0])
                ForEach(1 ..< 6) {i in
                    dailyCell(index: i, weather: viewModel.weather.daily[i])
                }
                
                Rectangle().frame(height: 40.0).opacity(0)
            }
        })
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
        .edgesIgnoringSafeArea(.all)
//        .sheet(isPresented: $presetnKey) {
//                PresentView()
//        }
        .fullScreenCover(isPresented: $presetnKey, content: {
            SetCityView(viewModel: self.viewModel)
        }).onChange(of: scenePhase) { newPhase in
            switch newPhase {
                case .inactive:
                    print("inactive")
                case .active:
                    viewModel.refresh()
                    print("active")
                case .background:
                    print("background")
            }
        }
        
    }
    
    private func dailyCell(index: Int, weather: DailyWeather) -> some View {
        HStack {
            if index == -1 {
            Text("昨天").font(.custom("NotoSansSC-Regular", size: 18)).padding(.leading, 60.0)
            } else if index == 0 {
            Text("今天").font(.custom("NotoSansSC-Regular", size: 18)).padding(.leading, 60.0)
            } else {
                Text(viewModel.getDayFor(timestamp: weather.dt).uppercased()).font(.custom("NotoSansSC-Regular", size: 18)).padding(.leading, 60.0)
            }
            Spacer()
            Text(viewModel.getTempC(temp: weather.temp.min, isF: true))
                .font(.custom("NotoSansSC-Regular", size: 20)).foregroundColor(
                    Color(red: 0.51, green: 0.51, blue: 0.51))
            Text("  /  " + viewModel.getTempC(temp: weather.temp.max, isF: true))
                .font(.custom("NotoSansSC-Regular", size: 20))
            Spacer()
            Text(weather.weather[0].main).font(.custom("NotoSansSC-Regular", size: 18)).padding(.trailing, 60.0)
        }
        .padding(.bottom, 10)
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: WeatherViewModel(weatherService: WeatherService(), cityService: CityService()))
    }
}

extension Color {
    init(_ hex: UInt32, opacity:Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
