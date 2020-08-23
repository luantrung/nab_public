//
//  CityWeather+ViewModel.swift
//  NAB
//
//  Created by Trung Luân on 8/23/20.
//  Copyright © 2020 LuanLT. All rights reserved.
//

import Foundation

extension CityWeather {
    
    func toViewModel() -> [CityWeatherSectionModel] {
        guard let dailyWeathers = self.list else { return [] }
        let cellModels = dailyWeathers.map { dailyWeather in
            dailyWeather.toViewModel()
        }
        return [CityWeatherSectionModel(items: cellModels)]
    }
}
