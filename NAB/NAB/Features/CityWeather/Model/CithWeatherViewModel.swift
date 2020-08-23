//
//  CithWeatherViewModel.swift
//  NAB
//
//  Created by Trung Luân on 8/23/20.
//  Copyright © 2020 LuanLT. All rights reserved.
//

import Foundation
import RxDataSources

typealias CityWeatherDataSource = RxTableViewSectionedAnimatedDataSource<CityWeatherSectionModel>

struct CityWeatherSectionModel {
    
    let identity = 0
    let items: [CityWeatherCellModel]
}

extension CityWeatherSectionModel: AnimatableSectionModelType {
    
    init(original: CityWeatherSectionModel, items: [CityWeatherCellModel]) {
        self.items = items
    }
}

struct CityWeatherCellModel: Equatable, IdentifiableType {
    
    let identity: Double
    let date: String?
    let temperature: String?
    let pressure: String?
    let humidity: String?
    let description: String?
}
