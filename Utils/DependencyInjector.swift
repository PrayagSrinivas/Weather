//
// DependencyInjector.swift
// Weather
// Created by Srinivas Prayag Sahu on 21/05/24
//

import Foundation
import Swinject

@propertyWrapper
struct Inject<Component> {
	let wrappedValue: Component
	init() {
		self.wrappedValue = Resolver.shared.resolve(Component.self)
	}
}

class Resolver {
	static let shared = Resolver()
	private var container = buildContainer()

	func resolve<T>(_ type: T.Type) -> T {
		container.resolve(T.self)!
	}

	func setDependencyContainer(_ container: Container) {
		self.container = container
	}
}

private func buildContainer() -> Container {
	let container = Container()

    container.register(WeatherService.self) { _ in
        WeatherServiceImpl(weatherWebRepository: WeatherWebRepository(), weatherLocalRepository: WeatherLocalRepository())
    }
    .inObjectScope(.container)
    
	container.register(MainViewModel.self) { resolver  in
		MainViewModel(weatherService: resolver.resolve(WeatherService.self)!)
	}
	.inObjectScope(.container)

	container.register(WeatherViewModel.self) { resolver  in
		let mainViewModel = resolver.resolve(MainViewModel.self)!
		return WeatherViewModel(localWeather: mainViewModel.localWeather, place: mainViewModel.selectedPlace)
	}
	.inObjectScope(.transient)

	return container
}
