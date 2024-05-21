//
// WeatherLocalRepository.swift
// Weather
// Created by Srinivas Prayag Sahu on 21/05/24
//

import Combine
import Foundation

class WeatherLocalRepository {
	private static var documentsFolder: URL {
		do {
			return try FileManager.default.url(for: .documentDirectory,
												  in: .userDomainMask,
												  appropriateFor: nil,
												  create: false)
		} catch {
			fatalError("Can't find documents directory.")
		}
	}
	private static var fileURL: URL {
		return documentsFolder.appendingPathComponent("places.data")
	}

	init() { }

	func loadPlaces() -> AnyPublisher<[Place], Never> {
		return Future { promise in
			DispatchQueue.global(qos: .background).async {
				guard let data = try? Data(contentsOf: Self.fileURL) else {
					return
				}
				guard let places = try? JSONDecoder().decode([Place].self, from: data) else {
					fatalError("Can't decode saved data.")
				}
				promise(.success(places))
			}
		}
		.receive(on: DispatchQueue.main)
		.eraseToAnyPublisher()
	}

	func savePlaces(places: [Place]) -> AnyPublisher<Void, Never> {
		return Future { promise in
			DispatchQueue.global(qos: .background).async {
				guard let data = try? JSONEncoder().encode(places) else { fatalError("Error encoding data") }
				do {
					let outfile = Self.fileURL
					try data.write(to: outfile)
					promise(.success(()))
				} catch {
					fatalError("Can't write to file")
				}
			}
		}
		.receive(on: DispatchQueue.main)
		.eraseToAnyPublisher()
	}
}
