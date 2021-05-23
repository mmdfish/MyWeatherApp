//
//  WeatherService.swift
//  MyWeatherApp
//
//  Created by fish on 2021/5/16.
//

import Foundation
import CoreLocation

public final class WeatherService2: NSObject {
    private let locationManager = CLLocationManager()
    private var completionHandler: ((CLLocation?, WeatherData?, LocationAuthError?) -> Void)?
    private var dataTask: URLSessionDataTask?
    
    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = CLLocationDistanceMax
    }
    
    func getWeatherData(
        _ completionHandler: @escaping((CLLocation?, WeatherData?, LocationAuthError?) -> Void)
    ) {
        self.completionHandler = completionHandler
        loadDataOrRequestLocationAuth()
    }
    
    private func loadDataOrRequestLocationAuth() {
      switch locationManager.authorizationStatus {
      case .authorizedAlways, .authorizedWhenInUse:
        locationManager.startUpdatingLocation()
      case .denied, .restricted:
        completionHandler?(nil, nil, LocationAuthError())
      default:
        locationManager.requestWhenInUseAuthorization()
      }
    }
    
    private func makeDataRequest(fromLocation location: CLLocation) {
        let coorddd:CLLocationCoordinate2D? = location.coordinate
        
        guard let coord = coorddd else {return}
        
        let urlString = OpenWeatherAPI.getCurrentURLFor(lat: coord.latitude, lon: coord.longitude)
        
        NetworkManager<WeatherData>.fetch(for: URL(string: urlString)!) { (result) in
            switch result {
            case .success(let response):
                self.completionHandler?(location, response, nil)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getAdderess(fromLocation location: CLLocation, handler: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        var address: String? = nil
        geocoder.reverseGeocodeLocation(location) {(placemarks, error) in
            guard error == nil else {
                return
            }
            print("start to get placemark")
            
            guard let placemark = placemarks?[0] else {
                            return
                        }
            print("\(placemark)")
            if let city = placemark.subLocality {
                address = city
                return
            }
            
            if let city = placemark.locality {
                address = city
                return
            }
        }
        handler(address)
    }
    
//    func getAdderess(fromLocation location: CLLocation) -> String? {
//        let geocoder = CLGeocoder()
//        var address: String?
//        geocoder.reverseGeocodeLocation(location) {(placemarks, error) in
//            guard error == nil else {
//                return
//            }
//            print("start to get placemark")
//
//            guard let placemark = placemarks?[0] else {
//                            return
//                        }
//            print("\(placemark)")
//            if let city = placemark.subLocality {
//                address = city
//                return
//            }
//
//            if let city = placemark.locality {
//                address = city
//                return
//            }
//        }
//        return address
//    }
}

extension WeatherService2: CLLocationManagerDelegate {
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        print("didUpdateLocations \(locations)")
        guard let location = locations.first else { return }
        //guard let location = manager.location else { return }
        print("didGetAddress \(location)")
        makeDataRequest(fromLocation: location)
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

