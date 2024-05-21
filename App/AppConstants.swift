//
// AppConstants.swift
// Weather
// Created by Srinivas Prayag Sahu on 21/05/24
//


import Foundation

enum AppConstants {
	enum Api {
		static let apiUrl = URL(string: "https://api.worldweatheronline.com/premium/v1")!
		static let apiKey = "387044d15c81418688951152242105"

		enum QueryKey: String {
			case apiKey = "key"
			case searchString = "q"
			case format = "format"

			// Weather Query
			case numOfDays = "num_of_days"
			case forcast = "fx"
			case currentCondition = "cc"
			case monthlyCondition = "mca"
			case location = "includelocation"
			case comments = "show_comments"
			case tp = "tp"
		}

		enum QueryValue {
			static let numOfDays = "5"
			static let forcast = "yes"
			static let currentCondition = "yes"
			static let monthlyCondition = "no"
			static let location = "no"
			static let comments = "no"
			static let tp = "1"
		}
	}
}
