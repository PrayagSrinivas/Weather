//
// WeatherService.swift
// Weather
// Created by Srinivas Prayag Sahu on 21/05/24
//

import Combine
import Foundation

protocol WeatherService {
	func search(for location: String) -> AnyPublisher<[Place], WeatherApiError>
	func fetchWeather(for place: Place) -> AnyPublisher<LocalWeather, WeatherApiError>
	func loadPlaces() -> AnyPublisher<[Place], Never>
	func savePlaces(places: [Place]) -> AnyPublisher<Void, Never>
}

struct WeatherServiceImpl: WeatherService {
	private var weatherWebRepository: WeatherWebRepository
	private var weatherLocalRepository: WeatherLocalRepository

	init(weatherWebRepository: WeatherWebRepository, weatherLocalRepository: WeatherLocalRepository) {
		self.weatherWebRepository = weatherWebRepository
		self.weatherLocalRepository = weatherLocalRepository
	}

	func fetchWeather(for place: Place) -> AnyPublisher<LocalWeather, WeatherApiError> {
		return weatherWebRepository.fetchWeather(location: "\(place.name), \(place.region ?? ""), \(place.country ?? "")")
	}

	func search(for location: String) -> AnyPublisher<[Place], WeatherApiError> {
		return weatherWebRepository.searchLocation(location: location)
	}

	func loadPlaces() -> AnyPublisher<[Place], Never> {
		return weatherLocalRepository.loadPlaces()
	}

	func savePlaces(places: [Place]) -> AnyPublisher<Void, Never> {
		return weatherLocalRepository.savePlaces(places: places)
	}
}
