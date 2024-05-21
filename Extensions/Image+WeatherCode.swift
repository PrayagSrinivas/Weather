//
// Image+WeatherCode.swift
// Weather
// Created by Srinivas Prayag Sahu on 21/05/24
//

import SwiftUI

extension Image {
	static func weatherCodeToImage(code: String, isNight: Bool = false) -> Image? {
		guard let code = Int(code) else { return nil }
		switch code {
			case 395:
				return Image(systemName: "cloud.snow.fill")
			case 392:
				return isNight ? Image(systemName: "cloud.moon.bolt.fill") : Image(systemName: "cloud.sun.bolt.fill")
			case 389:
				return Image(systemName: "cloud.bolt.fill")
			case 386:
				return isNight ? Image(systemName: "cloud.moon.bolt.fill") : Image(systemName: "cloud.sun.bolt.fill")
			case 377:
				return Image(systemName: "cloud.sleet.fill")
			case 374:
				return Image(systemName: "cloud.sleet.fill")
			case 371:
				return Image(systemName: "cloud.snow.fill")
			case 368:
				return Image(systemName: "cloud.heavyrain.fill")
			case 365:
				return isNight ? Image(systemName: "cloud.moon.rain.fill") : Image(systemName: "cloud.sun.rain.fill")
			case 362:
				return isNight ? Image(systemName: "cloud.moon.rain.fill") : Image(systemName: "cloud.sun.rain.fill")
			case 359:
				return Image(systemName: "cloud.heavyrain.fill")
			case 356:
				return isNight ? Image(systemName: "cloud.moon.rain.fill") : Image(systemName: "cloud.sun.rain.fill")
			case 353:
				return isNight ? Image(systemName: "cloud.moon.rain.fill") : Image(systemName: "cloud.sun.rain.fill")
			case 350:
				return Image(systemName: "cloud.sleet.fill")
			case 338:
				return Image(systemName: "cloud.snow.fill")
			case 335:
				return Image(systemName: "cloud.snow.fill")
			case 332:
				return Image(systemName: "cloud.snow.fill")
			case 329:
				return Image(systemName: "cloud.snow.fill")
			case 326:
				return Image(systemName: "cloud.snow.fill")
			case 323:
				return Image(systemName: "cloud.snow.fill")
			case 320:
				return Image(systemName: "cloud.snow.fill")
			case 317:
				return Image(systemName: "cloud.sleet.fill")
			case 314:
				return Image(systemName: "cloud.sleet.fill")
			case 311:
				return Image(systemName: "cloud.sleet.fill")
			case 308:
				return Image(systemName: "cloud.sleet.fill")
			case 305:
				return Image(systemName: "cloud.heavyrain.fill")
			case 302:
				return Image(systemName: "cloud.heavyrain.fill")
			case 299:
				return isNight ? Image(systemName: "cloud.moon.rain.fill") : Image(systemName: "cloud.sun.rain.fill")
			case 296:
				return Image(systemName: "cloud.drizzle.fill")
			case 293:
				return Image(systemName: "cloud.drizzle.fill")
			case 284:
				return Image(systemName: "cloud.sleet.fill")
			case 281:
				return Image(systemName: "cloud.sleet.fill")
			case 266:
				return Image(systemName: "cloud.drizzle.fill")
			case 263:
				return isNight ? Image(systemName: "cloud.moon.rain.fill") : Image(systemName: "cloud.sun.rain.fill")
			case 260:
				return Image(systemName: "cloud.fog.fill")
			case 248:
				return Image(systemName: "cloud.fog.fill")
			case 230:
				return Image(systemName: "cloud.snow.fill")
			case 227:
				return Image(systemName: "cloud.hail.fill")
			case 200:
				return isNight ? Image(systemName: "cloud.moon.bolt.fill") : Image(systemName: "cloud.sun.bolt.fill")
			case 185:
				return Image(systemName: "cloud.sleet.fill")
			case 182:
				return Image(systemName: "cloud.sleet.fill")
			case 179:
				return isNight ? Image(systemName: "cloud.moon.rain.fill") : Image(systemName: "cloud.sun.rain.fill")
			case 176:
				return isNight ? Image(systemName: "cloud.moon.rain.fill") : Image(systemName: "cloud.sun.rain.fill")
			case 143:
				return Image(systemName: "cloud.fog.fill")
			case 122:
				return Image(systemName: "cloud.fill")
			case 119:
				return Image(systemName: "cloud.fill")
			case 116:
				return isNight ? Image(systemName: "cloud.fill") : Image(systemName: "cloud.sun.fill")
			case 113:
				return isNight ? Image(systemName: "moon.circle.fill") : Image(systemName: "sun.max.fill")
			default:
				return nil
		}
	}
}
