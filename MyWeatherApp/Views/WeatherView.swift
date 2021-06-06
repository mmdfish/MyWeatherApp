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

    
    //UserDefaults.standard.set(self.isSetCity, forKey: "isCitySet")
    var body: some View {
        VStack(spacing:0, content: {
            Rectangle()
                .frame(height: 60.0).opacity(0)
            ZStack {
                Text(viewModel.cityName)
                    .font(.custom("NotoSansSC-Regular", size: 20))
                HStack {
                    Spacer()
                    Button(
                        action: {
                            self.presetnKey.toggle()
                        },
                        label: { Text("+").font(.custom("NotoSansSC-Regular", size: 40)).foregroundColor(Color.gray) }
                    ).padding(.trailing, 20)
                }
            }
            Rectangle()
                .frame(height: 72.0).opacity(0)
            HStack {
                Text("°")
                    .font(.custom("NotoSansCJKsc-DemiLight", size: 90))
                    .bold().opacity(0)
                Text(String(Int(viewModel.weather.current.temp)))
                    .font(.custom("NotoSansCJKsc-DemiLight", size: 90))
                    .bold()
                Text("°")
                    .font(.custom("NotoSansCJKsc-DemiLight", size: 90))
                    .bold()
            }
            Rectangle()
                .frame(height: 28.0).opacity(0)
            Text(String(viewModel.weather.current.weather[0].main))
                .font(.custom("NotoSansSC-Regular", size: 20))
            HStack {
                Text("20")
                    .font(.custom("NotoSansSC-Regular", size: 20)).foregroundColor(
                        Color(red: 0.51, green: 0.51, blue: 0.51))
                Text("  /  28")
                    .font(.custom("NotoSansSC-Regular", size: 20))
            }
            
            Text(String("西风    4级"))
                .font(.custom("NotoSansSC-Regular", size: 20))
            Rectangle().opacity(0)
            
            VStack {
                ForEach(0 ..< 7) {_ in
                    HStack {
                        Text(String("昨天")).font(.custom("NotoSansSC-Regular", size: 18)).padding(.leading, 60.0)
                        Spacer()
                        Text(String("20 / 28")).font(.custom("NotoSansSC-Regular", size: 18))
                        Spacer()
                        Text(String("晴")).font(.custom("NotoSansSC-Regular", size: 18)).padding(.trailing, 60.0)
                    }
                    .padding(.bottom, 10)
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

}

struct WeatherView2: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack(spacing:0) {
            Rectangle()
                .frame(height: 60.0).opacity(0)
            //      Text(viewModel.cityName)
            //        .font(.system(size: 20)
            Text("朝阳区")
                .font(.custom("NotoSansSC-Regular", size: 20))
            Rectangle()
                .frame(height: 72.0).opacity(0)
            HStack {
                Text("°")
                    .font(.custom("NotoSansCJKsc-DemiLight", size: 90))
                    .bold().opacity(0)
                Text(String(Int(viewModel.weather.current.temp)))
                    //                .font(.system(size: 90))
                    .font(.custom("NotoSansCJKsc-DemiLight", size: 90))
                    //NotoSansCJKsc-DemiLight
                    //NotoSansSC-Regular
                    .bold()
                Text("°")
                    .font(.custom("NotoSansCJKsc-DemiLight", size: 90))
                    .bold()
            }
            Rectangle()
                .frame(height: 28.0).opacity(0)
            Text(String(viewModel.weather.current.weather[0].main))
                .font(.custom("NotoSansSC-Regular", size: 20))
            //        Text(String(viewModel.weather.daily[0].temp.min) + " / " + String(viewModel.weather.daily[0].temp.max))
            //        .font(.system(size: 20))
            HStack {
                Text("20")
                    .font(.custom("NotoSansSC-Regular", size: 20)).foregroundColor(
                        //                    Color(0x838383))
                        Color(red: 0.51, green: 0.51, blue: 0.51))
                //            red: 0.51, green: 0.51, blue: 0.51, alpha: 1
                Text("  /  28")
                    .font(.custom("NotoSansSC-Regular", size: 20))
            }
            
            Text(String("西风    4级"))
                .font(.custom("NotoSansSC-Regular", size: 20))
            Rectangle().opacity(0)
            
            VStack {
                ForEach(0 ..< 7) {_ in
                    HStack {
                        Text(String("昨天")).font(.custom("NotoSansSC-Regular", size: 18)).padding(.leading, 60.0)
                        Spacer()
                        Text(String("20 / 28")).font(.custom("NotoSansSC-Regular", size: 18))
                        Spacer()
                        Text(String("晴")).font(.custom("NotoSansSC-Regular", size: 18)).padding(.trailing, 60.0)
                    }
                    .padding(.bottom, 10)
                }
                
                Rectangle().frame(height: 40.0).opacity(0)
            }
            
            //        HStack {
            //            Text(String("西风    4级"))
            //            Text(String("西风    4级"))
            //        }
            
            //        Rectangle()
            //            .frame(height: 40.0).opacity(0)
            //        Text(viewModel.weather.current.weather.description)
            //        Text(viewModel.yesterdayWeather.weather.description)
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
        .edgesIgnoringSafeArea(.all)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: WeatherViewModel(weatherService: WeatherService()))
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
