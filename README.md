# Weather

The SwiftUI Weather app, allows users to get the current weather for a particular location and view a 5-day weather forecast for the selected place. Powered by World Weather Online API.

### Features
* Add and remove a place.
* Place list is persisted locally
* Share the item details with others
* Display the hourly weather forecast for each day
* Display the Daily weather forecast upto 5 days. 

## How to Work with the Source
* To get the Weather app work, just load the SPM Packages, and you can run it on your latest running iOS Device.

### Architecture
* This app is made using MVVM Architecture.
* Let me brief here about the components: View Model, Service, Repository, Model, View.
* Repository can only interacts with service layer, and service only interacts with view model.
* And Viewmodel handles all the business logic, which can be conveyed to View, and based upon the current state on view model, view will render accordingly.

