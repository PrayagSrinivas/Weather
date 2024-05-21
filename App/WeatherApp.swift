//
// WeatherApp.swift
// Weather
// Created by Srinivas Prayag Sahu on 21/05/24
//

import Logging
import SwiftUI

var logger = Logger(label: "com.weatherapp.srinivas.main")

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
			MainView()
				.preferredColorScheme(.dark)
        }
    }
}
