//
//  MainViewState.swift
//  Weather
//
//  Created by Srinivas Prayag Sahu on 21/05/24.
//

import Foundation

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
