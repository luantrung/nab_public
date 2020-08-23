# NAB Test Application

For the simplicity of the test, this app uses MVP architecture with the help of Repository pattern to manage cahing system.

- Language: Swift
- Third party libraries: RxSwift, Moya, Reusable

## How to run?

- Open `NAB.xcworkspace`, wait a moment for it to fetch dependencies (Package Manager).
- You are good to go.

## Features

### Repository

This pattern helps managing the flow of data between network and local, so the Presenter layer doesn't have to worry about it, this is all the presenter cares about:

```
protocol CityWeatherService {

    func getWeather(city: String) -> Observable<CityWeather>

}
```

There are 3 main elements inside Repository:

 - a `RemoteRepository` protocol to help fetching data from server
 - a `LocalRepository` protocol to help reading and saving data to local
 - a `FetchStrategy` contains the logic of how data is stored and fetched. In this example, I use `FetchCacheElseRemoteStrategy` . This is actually Strategy pattern.
 
 Because of the requirement, I only use a small caching library called `Cache`. However, we can easily replace it by Realm or CoreData in `LocalRepository` layer, it won't affect anything to Presenter layer.

### MVP architecture

With only 1 screen, there is no need for router, so using VIPER or RIBs is overkill.

- `DependencyContainer`: all singleton and 3rd parties will be placed here, then will be injected when creating objects (using Factory pattern).

### Searching

- It only search if user stops typing for 0.5 seconds
- search string will be converted from "Sài Gòn" to "saigon"
- The app first will look in the cache for the key "saigon", and return immediately if data is found.


## What need to be Improment

- A code generting tool to help manage localization (Like Swiftgen)
- Code convention (Swiftlint)
- A button to reload if there is any error (Huge UX improment)
- Unit test
