//
// KeyedEncodingContainer+Helpers.swift
// Weather
// Created by Srinivas Prayag Sahu on 21/05/24
//

import Foundation

extension KeyedEncodingContainer {
	mutating func encodeStringIfPresent(_ value: String?, forKey key: KeyedEncodingContainer<K>.Key) throws {
		if let text = value {
			let dict = ["value": text]
			let list = [dict]
			try self.encode(list, forKey: key)
		}
	}

	mutating func encodeDoubleIfPresent(_ value: Double?, forKey key: KeyedEncodingContainer<K>.Key) throws {
		if let text = value {
			try self.encode(String(text), forKey: key)
		}
	}

	mutating func encodeIntIfPresent(_ value: Int?, forKey key: KeyedEncodingContainer<K>.Key) throws {
		if let text = value {
			try self.encode(String(text), forKey: key)
		}
	}
}
