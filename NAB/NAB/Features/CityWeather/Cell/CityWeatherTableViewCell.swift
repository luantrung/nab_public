//
//  CityWeatherTableViewCell.swift
//  NAB
//
//  Created by Trung Luân on 8/22/20.
//  Copyright © 2020 LuanLT. All rights reserved.
//

import UIKit
import Reusable

class CityWeatherTableViewCell: UITableViewCell, NibReusable {
    
    // MARK: Outlets
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func update(data: CityWeatherCellModel) {
        dateLabel.text = data.date
        temperatureLabel.text = data.temperature
        pressureLabel.text = data.pressure
        humidityLabel.text = data.humidity
        descriptionLabel.text = data.description
    }
}
