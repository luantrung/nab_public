//
//  Repository.swift
//
//  Created by Trung Luân on 4/29/20.
//

import Foundation
import RxSwift

public protocol DataModel: RemoteDataModel, LocalDataModel {}

public protocol Repository {
    
    var remoteRepository: RemoteRepository { get }
    var localRepository: LocalRepository { get }
    
    func get<T: RemoteDataModel>(request: RemoteRequest) -> Observable<T>
    func get<T: DataModel>(policy: FetchPolicy) -> Observable<T>
    func get<S: FetchStrategyType>(strategy: S) -> Observable<S.DataType>
    
    func get<T: RemoteDataModel>(request: RemoteRequest) -> Observable<[T]>
    func get<T: DataModel>(policy: FetchPolicy) -> Observable<[T]>
    func get<S: FetchStrategyType>(strategy: S) -> Observable<[S.DataType]>
}

extension Repository {
    
    public func get<T: RemoteDataModel>(request: RemoteRequest) -> Observable<T> {
        let fetchStrategy = FetchRemoteOnlyStrategy<T>(remoteRepository: remoteRepository,
                                                       remoteRequest: request)
        return get(strategy: fetchStrategy)
    }
    
    public func get<T: DataModel>(policy: FetchPolicy) -> Observable<T> {
        let fetchStrategy: FetchStrategy<T> = makeFetchStrategy(policy: policy)
        return get(strategy: fetchStrategy)
    }
    
    public func get<S: FetchStrategyType>(strategy: S) -> Observable<S.DataType> {
        return strategy.fetch()
    }
    
    public func get<T: RemoteDataModel>(request: RemoteRequest) -> Observable<[T]> {
        let fetchStrategy = FetchRemoteOnlyStrategy<T>(remoteRepository: remoteRepository,
                                                       remoteRequest: request)
        return get(strategy: fetchStrategy)
    }
    
    public func get<T: DataModel>(policy: FetchPolicy) -> Observable<[T]> {
        let fetchStrategy: FetchStrategy<T> = makeFetchStrategy(policy: policy)
        return get(strategy: fetchStrategy)
    }
    
    public func get<S: FetchStrategyType>(strategy: S) -> Observable<[S.DataType]> {
        return strategy.fetch()
    }
}

/// Decide how the data is loaded
public enum FetchPolicy {
    
    /// Only get data from remote, use this if you always want up to date data
    case remoteOnly(remote: RemoteRequest)
    
    /// Looking for cache first, if cache is empty then get from remote
    case cacheElseRemote(remote: RemoteRequest, local: LocalRequest)
}

extension Repository {
    
    func makeFetchStrategy<T: DataModel>(policy: FetchPolicy) -> FetchStrategy<T> {
        switch policy {
            
        case let .remoteOnly(remote):
            return FetchRemoteOnlyStrategy<T>(remoteRepository: remoteRepository,
                                              remoteRequest: remote)
            
        case let .cacheElseRemote(remote, local):
            return FetchCacheElseRemoteStrategy<T>(remoteRepository: remoteRepository,
                                                   localRepository: localRepository,
                                                   remoteRequest: remote,
                                                   localRequest: local)
        }
    }
}
