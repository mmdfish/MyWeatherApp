//
//  WeatherService.swift
//  MyWeatherApp
//
//  Created by fish on 2021/5/16.
//

import Foundation
import CoreLocation

public final class WeatherService: NSObject {
    private let locationManager = CLLocationManager()
    private var completionHandler: ((CLLocation?, LocationAuthError?) -> Void)?
    private var dataTask: URLSessionDataTask?
    
    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = CLLocationDistanceMax
    }
    
    func reUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.startUpdatingLocation()
    }
    
    func getLocationData(
        _ completionHandler: @escaping((CLLocation?, LocationAuthError?) -> Void)
    ) {
        self.completionHandler = completionHandler
        loadDataOrRequestLocationAuth()
    }
    
    private func loadDataOrRequestLocationAuth() {
      switch locationManager.authorizationStatus {
      case .authorizedAlways, .authorizedWhenInUse:
        locationManager.startUpdatingLocation()
      case .denied, .restricted:
        completionHandler?(nil, LocationAuthError())
      default:
        locationManager.requestWhenInUseAuthorization()
      }
    }
    
    func getWeatherData(_ location: CLLocation, handler: @escaping (WeatherData?) -> Void) {
        let coorddd:CLLocationCoordinate2D? = location.coordinate
        
        guard let coord = coorddd else {return}
        
        let urlString = OpenWeatherAPI.getCurrentURLFor(lat: coord.latitude, lon: coord.longitude)
        print(urlString)
        
        NetworkManager<WeatherData>.fetch(for: URL(string: urlString)!) { (result) in
            switch result {
            case .success(let response):
                handler(response)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getHisWeatherData(_ location: CLLocation, handler: @escaping (HistoryWeatherData?) -> Void) {
        let coorddd:CLLocationCoordinate2D? = location.coordinate
        
        guard let coord = coorddd else {return}
        
        let yesterday: Date! = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let myTimeStamp = yesterday.timeIntervalSince1970
        
        let urlString = OpenWeatherAPI.getHistoryURLFor(lat: coord.latitude, lon: coord.longitude, dt: Int(myTimeStamp))
//        print(urlString)
        
        NetworkManager<HistoryWeatherData>.fetch(for: URL(string: urlString)!) { (result) in
            switch result {
            case .success(let response):
                handler(response)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getAdderess(_ location: CLLocation, handler: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) {(placemarks, error) in
            guard error == nil else {
                return
            }
            
            guard let placemark = placemarks?[0] else {
                            return
                        }
//            print("\(placemark)")
            if let city = placemark.subLocality {
                handler(city)
                return
            }
            
            if let city = placemark.locality {
                handler(city)
                return
            }
        }
    }
    
    func changeYesterdayWeather(_ yesWeather: HistoryWeatherData) -> DailyWeather {
        var dailyData = DailyWeather()
        dailyData.dt = 0
        dailyData.weather = yesWeather.hourly[13].weather
        var Temps = [Double]()
        for hourlyData in yesWeather.hourly {
            Temps.append(hourlyData.temp)
        }
        Temps.sort()
        dailyData.temp = Temperature(min: Temps[0], max: Temps[Temps.endIndex - 1])
        return dailyData
    }
}

extension WeatherService: CLLocationManagerDelegate {
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else { return }
        completionHandler?(location, nil)
    }
    
    
    

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        loadDataOrRequestLocationAuth()
    }
    public func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Something went wrong: \(error.localizedDescription)")
    }
}

public struct LocationAuthError: Error {}
