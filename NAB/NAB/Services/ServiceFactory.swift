//
//  ServiceFactory.swift
//  NAB
//
//  Created by Trung Luân on 8/23/20.
//  Copyright © 2020 LuanLT. All rights reserved.
//

import Foundation

protocol ServiceFactory {
    
    func makeCityWeatherService() -> CityWeatherService
}

// MARK: ServiceFactory

extension DependencyContainer {
    
    func makeCityWeatherService() -> CityWeatherService {
        return repository
    }
}
