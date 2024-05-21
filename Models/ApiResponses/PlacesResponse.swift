//
// PlaceResponse.swift
// Weather
// Created by Srinivas Prayag Sahu on 21/05/24
//

import Foundation

// MARK: - Search Location
struct PlacesResponce: Codable {
    let searchAPI: SearchAPI
    
    enum CodingKeys: String, CodingKey {
        case searchAPI = "search_api"
    }
}

// MARK: - SearchAPI
struct SearchAPI: Codable {
    let result: [Place]
}
