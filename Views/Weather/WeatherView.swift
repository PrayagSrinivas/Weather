//
// WeatherView.swift
// Weather
// Created by Srinivas Prayag Sahu on 21/05/24
//

import SwiftUI

struct WeatherView: View {
	@StateObject private var viewModel: WeatherViewModel = Resolver.shared.resolve(WeatherViewModel.self)
	var isSheet: Bool
	var canSave: Bool
	var addPlaceCallback: (() -> Void)?
	@Environment(\.presentationMode) var presentationMode

	var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            currentWeatherView
                            currentSummaryView

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(viewModel.hourSummaries) { hourly in
                                        HourSummaryView(temp: viewModel.tempFor(hourly: hourly), icon: viewModel.imageFor(hourly: hourly), time: viewModel.timeFor(hourly: hourly))
                                    }
                                }
                            }
                            .padding()

                            ForEach(viewModel.daySummaries) { weather in
                                DaySummaryView(day: viewModel.dayFor(weatherElement: weather), highTemp: viewModel.highTempFor(weatherElement: weather), lowTemp: viewModel.lowTempFor(weatherElement: weather), icon: viewModel.imageFor(weatherElement: weather))
                            }
                            .padding(.horizontal)
                        }
                    }
                    Spacer()
                }
            }
            .toolbar(content: {
                if isSheet {
                    ToolbarItem(placement: .navigation) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white)
                        })
                    }
                }
            })
        }

	}

	private var currentWeatherView: some View {
		return AnyView(
			HStack {
				VStack(spacing: 4) {
					Text(viewModel.placeName)
						.font(.title)
						.fontWeight(.medium)
					HStack {
						viewModel.currentWeatherIcon?
							.renderingMode(.original)
							.imageScale(.small)
						Text("\(viewModel.currentTemp)")
							.fontWeight(.semibold)
					}.font(.system(size: 54))
						.frame(maxWidth: .infinity)
					Text("\(viewModel.currentTempDescription) - \(GlobalText.feelsLike(viewModel.feelsLike))")
						.foregroundColor(.secondary)
				}
			}
		)
	}

	private var currentSummaryView: some View {
		return AnyView(
			VStack {
				ZStack {
					HStack {
						VStack(alignment: .leading, spacing: 6) {
							detailView(text: viewModel.sunriseTime,
									   image: .init(systemName: "sunrise"),
									   offset: .init(width: 0, height: -2))

							detailView(text: viewModel.sunsetTime,
									   image: .init(systemName: "sunset"),
									   offset: .init(width: 0, height: -2))
						}
						Spacer()
					}
					VStack(alignment: .leading, spacing: 6) {
						detailView(text: "UV: \(viewModel.uvIndex)",
								   image: .init(systemName: "sun.max"))

						detailView(text: viewModel.humidity,
								   image: .init(systemName: "humidity"))
					}

					HStack {
						Spacer()
						VStack(alignment: .leading, spacing: 6) {
							detailView(text: viewModel.windSpeed,
									   image: .init(systemName: "wind"))

							detailView(text: viewModel.windDirection,
									   image: .init(systemName: "arrow.up.right.circle"))
						}
					}
				}
				.padding()
			}
		)
	}

	private var sheetActionsView: some View {
		return AnyView(
			HStack {
				Button(GlobalText.cancel) {
					presentationMode.wrappedValue.dismiss()
				}
				Spacer()
				if canSave {
					Button(GlobalText.add) {
						addPlaceCallback?()
						presentationMode.wrappedValue.dismiss()
					}
				}
			}.padding())
	}

	private var dismissButtonView: some View {
		return AnyView(
			HStack {
				Button(action: {
					presentationMode.wrappedValue.dismiss()
				}, label: {
					Image(systemName: "list.star")
						.foregroundColor(.white)
						.padding(8)
						.overlay(
							RoundedRectangle(cornerRadius: 8)
								.stroke(Color.white.opacity(0.2), lineWidth: 1)
						)
				})

				Spacer()
			}.padding([.top, .leading])
		)
	}

	private func detailView(text: String, image: Image, offset: CGSize = .zero) -> some View {
		HStack {
			image
				.imageScale(.medium)
				.foregroundColor(WeatherColor.AccentColor)
				.offset(offset)
			Text(text)
		}
	}
}
