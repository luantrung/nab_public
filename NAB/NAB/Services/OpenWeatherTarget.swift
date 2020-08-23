//
//  OpenWeatherTarget.swift
//  NAB
//
//  Created by Trung Luân on 8/21/20.
//  Copyright © 2020 LuanLT. All rights reserved.
//

import Foundation
import Moya

protocol OpenWeatherTargetType: TargetType {}

extension OpenWeatherTargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/") else {
            fatalError("baseURL cannot be empty")
        }
        return url
    }
    
    var headers: [String: String]? { nil }
    
    var parameterEncoding: ParameterEncoding { JSONEncoding.default }
    
    var sampleData: Data { Data() }
}
