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
            //            Button("点击按钮返回") {
            //                self.viewModel.setIsCitySet(true)
            //                self.viewModel.setCity("Beijing", CLLocation(latitude: 39.92, longitude: 116.42))
            //                self.viewModel.refresh()
            //                self.presentationMode.wrappedValue.dismiss()
            //            }.font(.system(size: 30))
            //            .foregroundColor(.green)
            //            .background(Color.white)
            
            HStack {
                
//                Button(action:{
//                    print("边框的按钮2")
//                }){
//                    Text("边框的按钮2")
//                        .padding()
//                        .background(RoundedRectangle(cornerRadius: 10)
//                                        .stroke(Color.green,lineWidth: 2)
//                        )
//
//                }.padding()
                
                Button(action: {
                    self.viewModel.setIsCitySet(false)
                    self.viewModel.refresh()
                    self.presentationMode.wrappedValue.dismiss()
                    
                }) {
                    Text("Location")
                        .font(.system(size: 30))
//                        .padding()
                        .frame(width: 120.0, height: 40.0)
                        .background(RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.gray,lineWidth: 2)
                        )
                }
                
                Button(action: {
                    self.viewModel.setIsCitySet(true)
                    self.viewModel.setCity("Beijing", CLLocation(latitude: 39.92, longitude: 116.42))
                    self.viewModel.refresh()
                    self.presentationMode.wrappedValue.dismiss()
                    
                }) {
                    Text("Beijing")
                        .font(.system(size: 30))
//                        .padding()
                        .frame(width: 120.0, height: 40.0)
                        .background(RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.gray,lineWidth: 2)
                        )
                }
                
                Button(action: {
                    self.viewModel.setIsCitySet(true)
                    self.viewModel.setCity("Chengdu", CLLocation(latitude: 104.07, longitude: 30.67))
                    self.viewModel.refresh()
                    self.presentationMode.wrappedValue.dismiss()
                    
                }) {
                    Text("Chengdu")
                        .font(.system(size: 30))
//                        .padding()
                        .frame(width: 120.0, height: 40.0)
                        .background(RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.gray,lineWidth: 2)
                        )
                }
                
            }
            
        }.edgesIgnoringSafeArea(.all)
    }
}

struct SetCityView_Previews: PreviewProvider {
    static var previews: some View {
        SetCityView(viewModel: WeatherViewModel(weatherService: WeatherService()))
    }
}
