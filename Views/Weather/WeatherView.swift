//
// WeatherView.swift
// Weather
// Created by Srinivas Prayag Sahu on 21/05/24
//

import SwiftUI

struct WeatherView: View {
    
    // MARK: Properties
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: WeatherViewModel = Resolver.shared.resolve(WeatherViewModel.self)
    
    var isSheet: Bool
    var canSave: Bool
    var addPlaceCallback: (() -> Void)?
    
    // MARK: Body
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                spacer
                currentWeatherView
                currentSummaryView
                hourSummary
                daySummary
            }
            Spacer()
        }
        .background {
            BackgroundView()
        }
        .navigationTitle("\(viewModel.placeName) - \(viewModel.currentTemp)")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .top) {
            navBar
        }
    }
    
    // MARK: Views
    private var currentWeatherView: some View {
        HStack {
            VStack(spacing: 4) {
                currentPlaceTitle
                currentTemperature
                currentTempDescription
            }
        }
    }
    
    private var currentSummaryView: some View {
        VStack {
            ZStack {
                sunStateView
                uvIndexView
                windDetailsView
            }
            .padding()
        }
    }
    
    private var sunStateView: some View {
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
    }
    
    private var uvIndexView: some View {
        VStack(alignment: .leading, spacing: 6) {
            detailView(text: "UV: \(viewModel.uvIndex)",
                       image: .init(systemName: "sun.max"))
            
            detailView(text: viewModel.humidity,
                       image: .init(systemName: "humidity"))
        }
    }
    
    private var windDetailsView: some View {
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
    
    private func detailView(text: String, image: Image, offset: CGSize = .zero) -> some View {
        HStack {
            image
                .imageScale(.medium)
                .foregroundColor(.white)
                .offset(offset)
            Text(text)
        }
    }
    
    private var currentTemperature: some View {
        HStack {
            viewModel.currentWeatherIcon?
                .renderingMode(.original)
                .imageScale(.small)
            Text("\(viewModel.currentTemp)")
                .fontWeight(.semibold)
        }
        .font(.system(size: 54))
        .frame(maxWidth: .infinity)
    }
    
    private var currentTempDescription: some View {
        Text("\(viewModel.currentTempDescription) - \(GlobalText.feelsLike(viewModel.feelsLike))")
            .foregroundColor(.secondary)
    }
    
    private var currentPlaceTitle: some View {
        Text(viewModel.placeName)
            .font(.title)
            .fontWeight(.medium)
    }
    
    private var daySummary: some View {
        ForEach(viewModel.daySummaries) { weather in
            DaySummaryView(
                day: viewModel.dayFor(weatherElement: weather),
                highTemp: viewModel.highTempFor(weatherElement: weather),
                lowTemp: viewModel.lowTempFor(weatherElement: weather),
                icon: viewModel.imageFor(weatherElement: weather)
            )
        }
        .padding(.horizontal)
    }
    
    private var hourSummary: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.hourSummaries) { hourly in
                    HourSummaryView(
                        temp: viewModel.tempFor(hourly: hourly),
                        icon: viewModel.imageFor(hourly: hourly),
                        time: viewModel.timeFor(hourly: hourly)
                    )
                }
            }
        }
        .padding()
    }

    @ViewBuilder
    private var addButton: some View {
        if canSave {
            Button(action: {
                addPlaceCallback?()
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(.white)
            })
        }
    }
    
    private var dismissButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.white)
        })
    }
    
    @ViewBuilder
    private var navBar: some View {
        if isSheet {
            ZStack {
                Text("\(viewModel.placeName) - \(viewModel.currentTemp)")
                    .font(.headline)
                toolbarButtons
            }
            .background(.ultraThinMaterial)
        }
    }
    
    private var toolbarButtons: some View {
        HStack {
            dismissButton.padding()
            Spacer()
            addButton.padding()
        }
    }
    
    @ViewBuilder
    private var spacer: some View {
        if isSheet {
            Spacer()
                .frame(height: 60)
        }
    }
}
