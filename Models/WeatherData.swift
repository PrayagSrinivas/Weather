//
//  WeatherData.swift
//  Weather
//
//  Created by Srinivas Prayag Sahu on 21/05/24.
//

import SwiftUI

class WeatherData: Identifiable {
    
    // MARK: Properties.
    let id = UUID()
    let place: Place
    var weather: LocalWeather?
    
    private var currentWeather: CurrentWeather? {
        return weather?.currentWeather.first
    }
    
    init(place: Place) {
        self.place = place
    }
    
    // MARK: Public Variables
    var placeName: String {
        var result = place.name
        if let placeRegion = place.region {
            result += " - \(placeRegion)"
        }
        return result
    }
    
    var currentTemp: String {
        currentWeather?.tempFormatted ?? ""
    }
    
    var currentTempDescription: String {
        currentWeather?.weatherDescription ?? ""
    }
    
    var image: Image? {
        guard let currentWeather = currentWeather else { return nil }
        
        return currentWeather.image(sunriseTime: sunriseTime, sunsetTime: sunsetTime)
    }
    
    var sunriseTime: String {
        guard let astronomy = weather?.dailyWeather.first?.astronomy.first else { return "" }
        
        return astronomy.sunriseFormatted
    }
    
    var sunsetTime: String {
        guard let astronomy = weather?.dailyWeather.first?.astronomy.first else { return "" }
        
        return astronomy.sunsetFormatted
    }
}

extension WeatherData: Equatable {
    static func == (lhs: WeatherData, rhs: WeatherData) -> Bool {
        lhs.id == rhs.id
    }
}
