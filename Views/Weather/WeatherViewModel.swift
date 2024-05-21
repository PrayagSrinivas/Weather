//
// WeatherViewModel.swift
// Weather
// Created by Srinivas Prayag Sahu on 21/05/24
//

import SwiftUI

class WeatherViewModel: ObservableObject {
    private let localWeather: LocalWeather?
    private let place: Place?
    
    private var currentWeather: CurrentWeather? {
        return localWeather?.currentWeather.first
    }
    
    // MARK: - Public properties
    var placeName: String {
        place?.name ?? ""
    }
    
    var hourSummaries: [Hourly] {
        guard let todayWeather = localWeather?.dailyWeather.first?.hourly else { return [] }
        
        // Filter the hourly weather elements that the current time have not passed
        return todayWeather.filter {
            guard let hourlyDate = Helpers.hourlyTimeToDate(timeFor(hourly: $0)) else { return false }
            let hourly = Calendar.current.component(.hour, from: hourlyDate)
            let now = Calendar.current.component(.hour, from: Date())
            
            return hourly > now
        }
    }
    
    var daySummaries: [WeatherElement] {
        localWeather?.dailyWeather ?? []
    }
    
    var currentTempDescription: String {
        currentWeather?.weatherDescription ?? ""
    }
    
    var currentWeatherIcon: Image? {
        guard let currentWeather = currentWeather else { return nil }
        
        return currentWeather.image(sunriseTime: sunriseTime, sunsetTime: sunsetTime)
    }
    
    var currentTemp: String {
        currentWeather?.tempFormatted ?? ""
    }
    
    var feelsLike: String {
        currentWeather?.feelsLikeFormatted ?? ""
    }
    
    var uvIndex: String {
        currentWeather?.uvIndexFormatted ?? ""
    }
    
    var humidity: String {
        currentWeather?.humidityFormatted ?? ""
    }
    
    var windSpeed: String {
        currentWeather?.windSpeedFormatted ?? ""
    }
    
    var windDirection: String {
        currentWeather?.windDirectionFormatted ?? ""
    }
    
    var sunriseTime: String {
        guard let astronomy = localWeather?.dailyWeather.first?.astronomy.first else { return "" }
        
        return astronomy.sunriseFormatted
    }
    
    var sunsetTime: String {
        guard let astronomy = localWeather?.dailyWeather.first?.astronomy.first else { return "" }
        
        return astronomy.sunsetFormatted
    }
    
    // MARK: - Constructor
    init(localWeather: LocalWeather?, place: Place?) {
        self.localWeather = localWeather
        self.place = place
    }
    
    // MARK: - Public Methods
    func tempFor(hourly: Hourly) -> String {
        return hourly.tempFormatted
    }
    
    func imageFor(hourly: Hourly) -> Image? {
        return hourly.image(sunriseTime: sunriseTime, sunsetTime: sunsetTime)
    }
    
    func timeFor(hourly: Hourly) -> String {
        return hourly.timeFormatted
    }
    
    func dayFor(weatherElement: WeatherElement) -> String {
        if let weather = daySummaries.first, weather.id == weatherElement.id {
            return "Today"
        }
        return weatherElement.day
    }
    
    func highTempFor(weatherElement: WeatherElement) -> String {
        return weatherElement.highTempFormatted
    }
    
    func lowTempFor(weatherElement: WeatherElement) -> String {
        return weatherElement.lowTempFormatted
    }
    
    func imageFor(weatherElement: WeatherElement) -> Image? {
        return weatherElement.image
    }
}
