//
//  LogPlugin.swift
//  NAB
//
//  Created by Trung Luân on 8/21/20.
//  Copyright © 2020 LuanLT. All rights reserved.
//

import Foundation
import Moya

final class LogPlugin: PluginType {
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let body = request.httpBody,
            let str = String(data: body, encoding: .utf8) {
            print("request to send: \(str))")
        }
        print(request)
        if let url = request.url?.absoluteString {
            print(url)
        }
        return request
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let body):
            print("Response:")
            if let json = try? JSONSerialization.jsonObject(with: body.data, options: .mutableContainers) {
                print(json)
            } else {
                let response = String(data: body.data, encoding: .utf8)!
                print(response)
            }
        case .failure( _):
            break
        }
    }
}
