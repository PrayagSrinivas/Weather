//
// Place.swift
// Weather
// Created by Srinivas Prayag Sahu on 21/05/24
//

import Foundation

// MARK: - Place
struct Place: Codable, Identifiable {
	let id = UUID()
	let name: String
	let country: String?
	let region: String?

	enum CodingKeys: String, CodingKey {
		case areaName, country, region
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		if let name = try container.decodeStringIfPresent(forKey: .areaName) {
			self.name = name
		} else {
			self.name = "Unknown"
		}

		country = try container.decodeStringIfPresent(forKey: .country)
		region = try container.decodeStringIfPresent(forKey: .region)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeStringIfPresent(name, forKey: .areaName)
		try container.encodeStringIfPresent(country, forKey: .country)
		try container.encodeStringIfPresent(region, forKey: .region)
	}
}

extension Place: Hashable {
	static func == (lhs: Place, rhs: Place) -> Bool {
		if lhs.name == rhs.name, lhs.region == rhs.region, lhs.region == rhs.region, lhs.country == rhs.country {
			return true
		}
		return false
	}
}
