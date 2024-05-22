# Weather

The SwiftUI Weather app, allows users to get the current weather for a particular location and view a 5-day weather forecast for the selected place. Powered by World Weather Online API.

### Features
* Add and remove a place.
* Place list is persisted locally
* Share the item details with others
* Display the hourly weather forecast for each day
* Display the Daily weather forecast upto 5 days. 

## How to Work with the Source
* Download Zip file from the respository link.
* Open the Weather.xcodeproj file
* To get the Weather app work, just load the SPM Packages, and you can run it on your latest running iOS Device.

### Architecture
* This app is made using MVVM Architecture.
* Let me brief here about the components: View Model, Service, Repository, Model, View.
* Repository can only interacts with service layer, and service only interacts with view model.
* And Viewmodel handles all the business logic, which can be conveyed to View, and based upon the current state on view model, view will render accordingly.

### UI Refernce


https://github.com/PrayagSrinivas/Weather/assets/78862797/64b07906-7cf4-400b-aad8-649445c1eced



https://github.com/PrayagSrinivas/Weather/assets/78862797/2547a141-ea16-48da-935f-7fa1c6086569



https://github.com/PrayagSrinivas/Weather/assets/78862797/c693fd64-3217-45f1-9ce1-565eebc3b848



https://github.com/PrayagSrinivas/Weather/assets/78862797/b049f9f3-c6d9-4c84-bc8e-f06d02c5d0cd


