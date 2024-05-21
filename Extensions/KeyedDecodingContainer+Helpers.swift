//
// KeyedDecodingContainer+Helpers.swift
// Weather
// Created by Srinivas Prayag Sahu on 21/05/24
//

import Foundation

extension KeyedDecodingContainer {
    func decodeStringIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> String? {
        let valueList = try self.decodeIfPresent([[String: String]].self, forKey: key)
        return valueList?.first?["value"]
    }
    
    func decodeNumericIfPresent<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T? where T: LosslessStringConvertible {
        if let value = try self.decodeIfPresent(String.self, forKey: key) {
            return T(value)
        }
        return nil
    }
}
