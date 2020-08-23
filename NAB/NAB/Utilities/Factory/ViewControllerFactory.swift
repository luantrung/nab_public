//
//  ViewControllerFactory.swift
//  NAB
//
//  Created by Trung Luân on 8/23/20.
//  Copyright © 2020 LuanLT. All rights reserved.
//

import UIKit

protocol ViewControllerFactory {
    
    func makeCityWeatherViewController() -> UIViewController
}

// MARK: DependencyContainer: ViewControllerFactory

extension DependencyContainer {
    
    func makeCityWeatherViewController() -> UIViewController {
        let viewController = CityWeatherViewController.instantiate()
        let cityWeatherService = makeCityWeatherService()
        let presenter = CityWeatherPresenter(view: viewController, service: cityWeatherService)
        viewController.presenter = presenter
        return viewController
    }
}
