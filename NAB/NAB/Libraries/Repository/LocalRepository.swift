//
//  LocalRepository.swift
//
//  Created by Trung Luân on 4/29/20.
//

import Foundation
import RxSwift

public protocol LocalDataModel: Codable {}

public enum LocalRequest {
    case none
    case object(key: String)
}

// MARK: LocalRepository

public protocol LocalRepository: AnyObject {
    
    func save<T: LocalDataModel>(_ data: T, request: LocalRequest)
    func get<T: LocalDataModel>(_ request: LocalRequest) -> Observable<T>
}
