//
//  RemoteRepository.swift
//
//  Created by Trung Luân on 4/29/20.
//

import Foundation
import Moya
import RxSwift

public protocol RemoteDataModel: Codable {}

// MARK: RemoteRepository

public protocol RemoteRepository: AnyObject {
    
    func request<T: RemoteDataModel>(_ remoteRequest: RemoteRequest) -> Observable<T>
    func request<T: RemoteDataModel>(_ remoteRequest: RemoteRequest) -> Observable<[T]>
}

// MARK: RemoteRequest

public struct RemoteRequest {
    
    public let target: TargetType
    public let keyPath: String?
    
    public init(target: TargetType,
                keyPath: String? = nil) {
        self.target = target
        self.keyPath = keyPath
    }
}
