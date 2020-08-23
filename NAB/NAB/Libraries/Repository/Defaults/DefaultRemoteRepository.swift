//
//  DefaultRemoteRepository.swift
//
//  Created by Trung Luân on 5/14/20.
//

import Foundation
import RxSwift
import Moya
import RxMoya

public final class DefaultRemoteRepository: RemoteRepository {
    
    private let provider: MoyaProvider<MultiTarget>
    private let networkQueue: DispatchQueue = DispatchQueue.global()
    private let decoder: JSONDecoder
    
    public init(decoder: JSONDecoder = JSONDecoder(),
                plugins: [PluginType] = []) {
        self.provider = MoyaProvider<MultiTarget>(plugins: plugins)
        self.decoder = decoder
    }
    
    public func request<T: RemoteDataModel>(_ remoteRequest: RemoteRequest) -> Observable<T> {
        return provider.rx
            .request(MultiTarget(remoteRequest.target), callbackQueue: networkQueue)
            .filterSuccessfulStatusCodes()
            .map(T.self, atKeyPath: remoteRequest.keyPath, using: decoder)
            .observeOn(MainScheduler.instance)
            .asObservable()
    }
    
    public func request<T: RemoteDataModel>(_ remoteRequest: RemoteRequest) -> Observable<[T]> {
        return provider.rx
            .request(MultiTarget(remoteRequest.target), callbackQueue: networkQueue)
            .filterSuccessfulStatusCodes()
            .map([T].self, atKeyPath: remoteRequest.keyPath, using: decoder)
            .observeOn(MainScheduler.instance)
            .asObservable()
    }
}
