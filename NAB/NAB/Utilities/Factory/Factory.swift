//
//  Factory.swift
//  NAB
//
//  Created by Trung Luân on 8/23/20.
//  Copyright © 2020 LuanLT. All rights reserved.
//

import Foundation

protocol Factory: ViewControllerFactory, ServiceFactory {}

extension DependencyContainer: Factory {}
