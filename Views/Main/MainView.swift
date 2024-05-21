//
// MainView.swift
// Weather
// Created by Srinivas Prayag Sahu on 21/05/24
//

import SimpleToast
import SwiftUI

struct MainView: View {
    
    @StateObject private var viewModel: MainViewModel = Resolver.shared.resolve(MainViewModel.self)
    
    var body: some View {
        NavigationStack {
            VStack {
                searchBar
                searchContent
                Spacer()
            }
            .background {
                BackgroundView()
            }
            .simpleToast(isPresented: $viewModel.showToast, options: viewModel.toastOptions) {
                toastView
            }
            .sheet(isPresented: $viewModel.weatherViewSheetPresented) {
                weatherDetailsView
            }
            .overlay {
                unavailableContentOverLay
            }
            .navigationTitle("Weather")
            .toolbar {
                toolbarButton
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    @ViewBuilder
    private var placesListView: some View {
        ScrollView(showsIndicators: false) {
            ForEach(viewModel.weathersData) { weatherData in
                HStack {
                   deleteWeatherCardButton(with: weatherData)
                    HStack {
                        weatherCard(with: weatherData)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .onTapGesture {
                        if viewModel.state == .editingPlaces {
                            viewModel.removeWeatherDate(weatherData)
                        } else {
                            viewModel.selectedPlace = weatherData.place
                        }
                    }
                }
                .animation(.bouncy, value: viewModel.state)
            }
        }
        .navigationDestination(isPresented: $viewModel.weatherViewPresented, destination: {
            WeatherView(isSheet: false, canSave: false)
        })
        .padding()
    }
    
    @ViewBuilder
    private var searchPlacesListView: some View {
        if viewModel.state == .loadingPlaces {
            ProgressView()
        } else if !viewModel.searchResults.isEmpty {
            List(viewModel.searchResults) { place in
                saveWeatherCarView(with: place)
            }
            .listStyle(.plain)
            .listRowSpacing(10)
            .padding()
        }
    }
    
    @ViewBuilder
    private var searchContent: some View {
        if viewModel.searchText.isEmpty {
            placesListView
        } else {
            searchPlacesListView
        }
    }
    
    private var searchBar: some View {
        SearchBar(searchText: $viewModel.searchText, placeholder: GlobalText.searchLocationPlaceholder)
            .padding()
    }
    
    private var toastView: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle")
            Text(viewModel.toastMessage)
        }
        .padding()
        .background(Color.red.opacity(0.8))
        .foregroundColor(Color.white)
        .cornerRadius(10)
        .offset(x: 0, y: -20)
    }
    
    private var weatherDetailsView: some View {
        WeatherView(isSheet: true, canSave: !viewModel.currentPlaceIsSaved) {
            viewModel.saveSelectedPlace()
        }
    }
    
    @ViewBuilder
    private var unavailableContentOverLay: some View {
        if !viewModel.searchText.isEmpty, viewModel.searchResults.isEmpty {
            ContentUnavailableView.search(text: viewModel.searchText)
        } else if viewModel.searchText.isEmpty, viewModel.weathersData.isEmpty {
            ContentUnavailableView("Save weather data to see here", systemImage: "square.and.arrow.down.on.square.fill")
        }
    }
    
    @ViewBuilder
    private var toolbarButton: some View {
        if (viewModel.canEditPlaces || viewModel.state == .editingPlaces) && viewModel.searchText.isEmpty {
            Button(action: {
                if viewModel.state == .editingPlaces {
                    viewModel.doneEditingPlaces()
                } else {
                    viewModel.editPlaces()
                }
            }, label: {
                if viewModel.state == .editingPlaces {
                    Text(GlobalText.done)
                } else {
                    Image(systemName: "pencil.circle")
                        .font(.system(size: 22, weight: .regular))
                }
            })
            .foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder
    private func deleteWeatherCardButton(with weatherData: WeatherData) -> some View {
        if viewModel.state == .editingPlaces {
            Button(action: {
                viewModel.removeWeatherDate(weatherData)
            }, label: {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(WeatherColor.AccentColor)
            })
            .frame(width: 20, height: 20)
        }
    }
    
    @ViewBuilder
    private func weatherCard(with weatherData: WeatherData) -> some View {
        VStack(alignment: .leading) {
            Text(weatherData.placeName)
                .fontWeight(.medium)
            Spacer()
            Text(weatherData.currentTempDescription)
                .font(Font.system(size: 12))
                .foregroundColor(.secondary)
        }
        Spacer()
        if viewModel.state == .fetchingWeathersData {
            ProgressView()
        } else {
            Text(weatherData.currentTemp)
                .fontWeight(.light)
            weatherData.image?
                .renderingMode(.original)
                .imageScale(.large)
        }
    }
    
    private func saveWeatherCarView(with place: Place) -> some View {
        HStack {
            Button("\(place.name), \(place.region ?? ""), \(place.country ?? "")") {
                viewModel.selectedPlace = place
            }
            .buttonStyle(PlainButtonStyle())
            
            if case let .fetchingWeatherForPlace(placeLoading) = viewModel.state,
               placeLoading == place {
                Spacer()
                ProgressView()
            }
        }
    }
}
