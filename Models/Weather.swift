//
// Weather.swift
// Weather
// Created by Srinivas Prayag Sahu on 21/05/24
//

import Foundation
import SwiftUI

// MARK: - DataClass
struct LocalWeather: Codable {
    let currentWeather: [CurrentWeather]
    let dailyWeather: [WeatherElement]
    
    enum CodingKeys: String, CodingKey {
        case currentWeather = "current_condition"
        case dailyWeather = "weather"
    }
}

// MARK: - CurrentCondition
struct CurrentWeather: Codable {
    private let observationTime, tempC, tempF, weatherCode: String
    private let windspeedKmph, winddir16Point: String
    private let humidity: String
    private let feelsLikeC, feelsLikeF, uvIndex: String
    private let weatherDesc: [StringValue]
    
    enum CodingKeys: String, CodingKey {
        case observationTime = "observation_time"
        case tempC = "temp_C"
        case tempF = "temp_F"
        case weatherCode, weatherDesc, windspeedKmph, winddir16Point, humidity, uvIndex
        case feelsLikeC = "FeelsLikeC"
        case feelsLikeF = "FeelsLikeF"
    }
    
    func image(sunriseTime: String, sunsetTime: String) -> Image? {
        guard let sunrise = Helpers.timeToDate(sunriseTime),
              let sunset = Helpers.timeToDate(sunsetTime),
              let time = Helpers.timeToDate(observationTime) else { return nil }
        
        return Image.weatherCodeToImage(code: weatherCode, isNight: Helpers.isNight(sunrise: sunrise, sunset: sunset, time: time))
    }
    
    var weatherDescription: String {
        weatherDesc.first?.value ?? ""
    }
    
    var tempFormatted: String {
        return tempC + "º"
    }
    
    var feelsLikeFormatted: String {
        return feelsLikeC + "º"
    }
    
    var uvIndexFormatted: String {
        return uvIndex
    }
    
    var humidityFormatted: String {
        return humidity + "%"
    }
    
    var windSpeedFormatted: String {
        return windspeedKmph + "km/h"
    }
    
    var windDirectionFormatted: String {
        return winddir16Point
    }
}

// MARK: - Weather
struct StringValue: Codable {
    let value: String
}

// MARK: - WeatherElement
struct WeatherElement: Codable, Identifiable {
    let id = UUID()
    let hourly: [Hourly]
    let astronomy: [Astronomy]
    private let date: String
    private let maxtempC, maxtempF, mintempC, mintempF: String
    
    enum CodingKeys: String, CodingKey {
        case date, astronomy, maxtempC, maxtempF, mintempC, mintempF, hourly
    }
    
    var highTempFormatted: String {
        maxtempC + "º"
    }
    
    var lowTempFormatted: String {
        mintempC + "º"
    }
    
    var image: Image? {
        Image.weatherCodeToImage(code: hourly.first?.weatherCode ?? "")
    }
    
    var day: String {
        Helpers.dayOfWeek(from: date) ?? ""
    }
}

// MARK: - Astronomy
struct Astronomy: Codable {
    let sunrise, sunset: String
    
    var sunriseFormatted: String {
        Helpers.formatAstronomyTime(from: sunrise) ?? ""
    }
    
    var sunsetFormatted: String {
        Helpers.formatAstronomyTime(from: sunset) ?? ""
    }
}

// MARK: - Hourly
struct Hourly: Codable, Identifiable {
    let id = UUID()
    let weatherCode: String
    private let time, tempC, tempF: String
    
    enum CodingKeys: String, CodingKey {
        case time, tempC, tempF, weatherCode
    }
    
    var timeFormatted: String {
        guard let time = Helpers.formatHourlyTime(time: time) else { return "" }
        return time
    }
    
    var tempFormatted: String {
        return tempC + "º"
    }
    
    func image(sunriseTime: String, sunsetTime: String) -> Image? {
        guard let sunrise = Helpers.timeToDate(sunriseTime),
              let sunset = Helpers.timeToDate(sunsetTime),
              let time = Helpers.hourlyTimeToDate(timeFormatted) else { return nil }
        
        return Image.weatherCodeToImage(code: weatherCode, isNight: Helpers.isNight(sunrise: sunrise, sunset: sunset, time: time))
    }
}

// MARK: - Helper Methods
enum Helpers {
    static func formatAstronomyTime(from value: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        guard let date = dateFormatter.date(from: value) else { return nil }
        
        return dateFormatter.string(from: date)
    }
    
    static func formatHourlyTime(time: String) -> String? {
        let hour = (Int(time) ?? 0) / 100
        
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "HH:mm"
        
        guard let oldDate = olDateFormatter.date(from: "\(hour):00") else { return nil }
        
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "h a"
        
        return convertDateFormatter.string(from: oldDate)
    }
    
    static func dayOfWeek(from value: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: value) else { return nil }
        
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    static func timeToDate(_ time: String) -> Date? {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.date(from: time)
    }
    
    static func hourlyTimeToDate(_ time: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        return formatter.date(from: time)
    }
    
    static func isNight(sunrise: Date, sunset: Date, time: Date) -> Bool {
        let hour = Calendar.current.component(.hour, from: time)
        let sunriseDate = Calendar.current.component(.hour, from: sunrise)
        let sunsetDate = Calendar.current.component(.hour, from: sunset)
        
        if hour >= sunsetDate || hour <= sunriseDate {
            return true
        }
        return false
    }
}
