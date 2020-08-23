//
//  CityWeatherService.swift
//  NAB
//
//  Created by Trung Luân on 8/21/20.
//  Copyright © 2020 LuanLT. All rights reserved.
//

import Foundation
import RxSwift
import Moya

protocol CityWeatherService {
    
    func getWeather(city: String) -> Observable<CityWeather>
}

extension NABRepository: CityWeatherService {
    
    func getWeather(city: String) -> Observable<CityWeather> {
        let historyTarget = CityWeatherTargets.GetWeather(cityName: city)
        let remoteRequest = RemoteRequest(target: historyTarget)
        let localRequest = LocalRequest.object(key: city)
        return get(policy: .cacheElseRemote(remote: remoteRequest, local: localRequest))
    }
}

// MARK: Targets

enum CityWeatherTargets {
    
    struct GetWeather: OpenWeatherTargetType {
        
        // MARK: Defaults
        
        var path: String { return "forecast/daily" }
        
        var method: Moya.Method { .get }
        
        var task: Task {
            .requestParameters(parameters: urlParameters, encoding: URLEncoding.default)
        }
        
        // MARK: Custom
        
        let cityName: String
        
        private var urlParameters: [String: Any] {
            ["q": cityName,
             "cnt": 7,
             "appid": "60c6fbeb4b93ac653c492ba806fc346d",
             "units": "metric"]
        }
    }
}

