//
//  DailyTemperature.swift
//  NAB
//
//  Created by Trung Luân on 8/21/20.
//  Copyright © 2020 LuanLT. All rights reserved.
//

import Foundation

struct DailyTemperature: Codable {
    
    private let min: Double?
    private let max: Double?
    
    var average: Double? {
        guard let min = min else { return max }
        guard let max = max else { return min }
        return (min + max) / 2
    }
}

