//
// MainViewModel.swift
// Weather
// Created by Srinivas Prayag Sahu on 21/05/24
//

import Combine
import SimpleToast
import SwiftUI

class WeatherData: Identifiable, Equatable {
	let id = UUID()
	let place: Place
	var weather: LocalWeather?

	static func == (lhs: WeatherData, rhs: WeatherData) -> Bool {
		lhs.id == rhs.id
	}

	private var currentWeather: CurrentWeather? {
		return weather?.currentWeather.first
	}

	init(place: Place) {
		self.place = place
	}

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

enum MainViewState: Equatable {
	case none
	case loadingPlaces
	case fetchingWeatherForPlace(place: Place)
	case fetchingWeathersData
	case editingPlaces

	static func == (lhs: MainViewState, rhs: MainViewState) -> Bool {
		switch (lhs, rhs) {
			case (.none, .none):
				return true
			case (.loadingPlaces, .loadingPlaces):
				return true
			case (.fetchingWeathersData, .fetchingWeathersData):
				return true
			case (.editingPlaces, .editingPlaces):
				return true
			case (.fetchingWeatherForPlace(let lhsPlace), .fetchingWeatherForPlace(let rhsPlace)):
				return lhsPlace == rhsPlace
			default:
				return false
		}
	}
}

class MainViewModel: ObservableObject {
	private let weatherService: WeatherService
	private var cancellables = Set<AnyCancellable>()

	// MARK: - Public properties
	@Published private(set) var state: MainViewState = .none {
		didSet {
			logger.trace("new state \(state)")
		}
	}
	@Published private(set) var localWeather: LocalWeather?
	@Published var searchText: String = ""
	@Published private(set) var searchResults = [Place]()
	@Published var weatherViewPresented = false
	@Published var weatherViewSheetPresented = false
	@Published var weathersData = [WeatherData]()
	@Published var showToast = false

	private(set) var toastMessage = ""
	private(set) var toastOptions = SimpleToastOptions(
		alignment: .bottom, hideAfter: 5, showBackdrop: false
	)

	var canEditPlaces: Bool {
		!weathersData.isEmpty
	}

	var currentPlaceIsSaved: Bool {
		guard let selectedPlace = selectedPlace else { return false }
		return weathersData.contains { $0.place == selectedPlace }
	}

	var selectedPlace: Place? {
		didSet {
			guard let selectedPlace = selectedPlace else { return }

			if let weatherData = weathersData.first(where: { $0.place == selectedPlace }), let weather = weatherData.weather {
				localWeather = weather

				self.state = .none
				// Show the Weather view as sheet if its a search result
				if self.searchText.isEmpty {
					self.weatherViewPresented = true
				} else {
					self.weatherViewSheetPresented = true
				}
			} else {
				fetchWeather(for: selectedPlace)
			}
		}
	}

	// MARK: - Constructor
	init(weatherService: WeatherService) {
		self.weatherService = weatherService
		// logger.logLevel = .trace
		$searchText
			.dropFirst()
			.debounce(for: .seconds(0.5), scheduler: DispatchQueue(label: "placesSearch", qos: .userInteractive))
			.receive(on: DispatchQueue.main)
			.sink(receiveValue: searchForPlaces(forLocation:))
			.store(in: &cancellables)

		weatherService.loadPlaces()
			.sink { [weak self] places in
				guard let self = self else { return }
				places.forEach {
					self.weathersData.append(WeatherData(place: $0))
				}
				self.fetchWeathers(for: self.weathersData)
			}
			.store(in: &cancellables)
	}

	// MARK: - Public Methods
	func saveSelectedPlace() {
		guard let place = selectedPlace else { return }
		searchText = ""
		weathersData.append(WeatherData(place: place))
		fetchWeather(for: place, showWeatherAfter: false, showError: false)

		let places = weathersData.map { $0.place }
		weatherService.savePlaces(places: places)
			.sink {}
			.store(in: &cancellables)
	}

	func editPlaces() {
		self.state = .editingPlaces
	}

	func doneEditingPlaces() {
		self.state = .none

		let places = weathersData.map { $0.place }
		weatherService.savePlaces(places: places)
			.sink {}
			.store(in: &cancellables)
	}

	func removeWeatherDate(_ data: WeatherData) {
		if let index = weathersData.firstIndex(of: data) {
			weathersData.remove(at: index)
		}
	}

	// MARK: - Private Methods
	private func searchForPlaces(forLocation location: String) {
		guard location.count > 1 else { return }
		logger.trace("searchForPlaces for location: \(location)")
		searchResults = []
		state = .loadingPlaces
		weatherService.search(for: location)
			.sink { [weak self] operationResult in
				switch operationResult {
					case .failure(let error):
						logger.error("\(error)")
					default:
						break
				}
				self?.state = .none
			} receiveValue: { places in
				logger.trace("searchForPlaces receiveValue: \(places) for location: \(location)")
				self.searchResults = places
			}
			.store(in: &cancellables)
	}

	private func fetchWeather(for place: Place, showWeatherAfter: Bool = true, showError: Bool = true, changeStateOnStart: Bool = true) {
		logger.trace("fetchWeather for place: \(place)")

		if changeStateOnStart {
			state = .fetchingWeatherForPlace(place: place)
		}

		weatherService.fetchWeather(for: place)
			.sink { [weak self] operationResult in
				guard let self = self else { return }

				switch operationResult {
					case .finished:
						self.state = .none
						if showWeatherAfter {
							// Show the Weather view as sheet if its a search result
							if self.searchText.isEmpty {
								self.weatherViewPresented = true
							} else {
								self.weatherViewSheetPresented = true
							}
						}
					case .failure(let error):
						logger.error("\(error)")
						if showError {
							self.toastMessage = error.localizedDescription
							self.showToast = true
						}
				}
			} receiveValue: { localWeather in
				logger.trace("fetchWeather receiveValue\(localWeather) for place: \(place)")

				if let weatherData = self.weathersData.first(where: { $0.place == place }) {
					weatherData.weather = localWeather
				}
				self.localWeather = localWeather
			}
			.store(in: &cancellables)
	}

	private func fetchWeathers(for weathersData: [WeatherData]) {
		logger.trace("fetchWeathers for weathersData\(weathersData)")
		state = .fetchingWeathersData

		weathersData.forEach { weatherData in
			fetchWeather(for: weatherData.place, showWeatherAfter: false, showError: false, changeStateOnStart: false)
		}
	}
}
