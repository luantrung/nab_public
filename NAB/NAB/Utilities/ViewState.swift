//
//  ViewState.swift
//  NAB
//
//  Created by Trung Luân on 8/23/20.
//  Copyright © 2020 LuanLT. All rights reserved.
//

import Foundation

enum ViewState<T> {
    case error(Error)
    case loading
    case empty
    case data(T)
}
