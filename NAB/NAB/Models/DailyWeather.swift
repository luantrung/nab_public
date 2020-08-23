//
//  DailyWeather.swift
//  NAB
//
//  Created by Trung Luân on 8/21/20.
//  Copyright © 2020 LuanLT. All rights reserved.
//

import Foundation

class DailyWeather: Codable {
    
    let date: Date?
    let temperature: DailyTemperature?
    let pressure: Double?
    let humidity: Double?
    
    var id: Double {
        return date?.timeIntervalSince1970 ?? Double(UUID().hashValue)
    }
    
    private enum CodingKeys: String, CodingKey {
        case date = "dt"
        case temperature = "temp"
        case pressure
        case humidity
    }
}
