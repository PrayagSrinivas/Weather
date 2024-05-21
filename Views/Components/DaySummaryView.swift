//
// DaySummaryView.swift
// Weather
// Created by Srinivas Prayag Sahu on 21/05/24
//

import SwiftUI

struct DaySummaryView: View {
	let day: String
	let highTemp: String
	let lowTemp: String
	let icon: Image?

	var body: some View {
		HStack {
			Text(day)
				.fontWeight(.medium)
			Spacer()
			Text("\(highTemp) / \(lowTemp)")
				.fontWeight(.light)
			icon?
				.renderingMode(.original)
				.imageScale(.large)
		}
		.padding(.horizontal)
		.padding(.vertical, 22)
		.background(Color(.secondarySystemBackground))
		.cornerRadius(10)
	}
}

struct DaySummaryView_Previews: PreviewProvider {
    static var previews: some View {
		return DaySummaryView(day: "Monday", highTemp: "19", lowTemp: "16", icon: Image(systemName: "sun.max.fill"))
    }
}
