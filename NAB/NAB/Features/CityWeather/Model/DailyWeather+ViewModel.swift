//
//  DailyWeather+ViewModel.swift
//  NAB
//
//  Created by Trung Luân on 8/23/20.
//  Copyright © 2020 LuanLT. All rights reserved.
//

import Foundation

extension DailyWeather {
    
    var displayedDate: String? {
        guard let date = date else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let formattedDate = formatter.string(from: date)
        /// Should use Swiftgen or similar tool for better localized strings management
        let formattedString = String(format: NSLocalizedString("Date: %@", comment: ""), formattedDate)
        return formattedString
    }
    
    var displayedTemperature: String? {
        return displayedString(format: NSLocalizedString("Average Temperature: %@", comment: ""),
                               value: temperature?.average,
                               unit: UnitTemperature.celsius)
    }
    
    var displayedPressure: String? {
        guard let value = pressure else { return nil }
        let formattedString = String(format: NSLocalizedString("Pressure: %.0f", comment: ""),
                                     value)
        return formattedString
    }
    
    var displayedHumidity: String? {
        guard let value = humidity else { return nil }
        let formattedString = String(format: NSLocalizedString("Humidity: %.0f%%", comment: ""),
                                     value)
        return formattedString
    }
    
    private func displayedString(format: String, value: Double?, unit: Unit) -> String? {
        guard let value = value else { return nil }
        /// Custom number formatter
        let numberFormatter = NumberFormatter()
        numberFormatter.generatesDecimalNumbers = false
        /// Measurement formatter
        let formatter = MeasurementFormatter()
        formatter.numberFormatter = numberFormatter
        let measurement = Measurement(value: value, unit: unit)
        let formattedValue = formatter.string(from: measurement)
        let formattedString = String(format: format, formattedValue)
        return formattedString
    }
}

extension DailyWeather {
    
    func toViewModel() -> CityWeatherCellModel {
        return CityWeatherCellModel(identity: self.id,
                                    date: self.displayedDate,
                                    temperature: self.displayedTemperature,
                                    pressure: self.displayedPressure,
                                    humidity: self.displayedHumidity,
                                    description: "no desc")
    }
}
