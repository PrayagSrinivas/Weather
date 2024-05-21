//
// BackgroundView.swift
// Weather
// Created by Srinivas Prayag Sahu on 21/05/24
//

import SwiftUI

struct BackgroundView: View {
	var body: some View {
		ZStack {
			LinearGradient(gradient:
							Gradient(colors: [
								WeatherColor.AppBackground,
								WeatherColor.AppBackground,
								WeatherColor.AccentColor,
							]), startPoint: .top, endPoint: .bottomTrailing)

			VisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark))
		}
		.edgesIgnoringSafeArea(.all)
	}
}

