//
//  FetchStrategyType.swift
//
//  Created by Trung Luân on 5/4/20.
//

import Foundation
import RxSwift

public protocol FetchStrategyType: AnyObject {
    
    associatedtype DataType
    
    func fetch() -> Observable<DataType>
    func fetch() -> Observable<[DataType]>
}

open class FetchStrategy<DataType>: FetchStrategyType {
    
    public init() {}
    
    open func fetch() -> Observable<DataType> {
        fatalError("Subclass must override this!")
    }
    
    open func fetch() -> Observable<[DataType]> {
        fatalError("Subclass must override this!")
    }
}

class FetchRemoteOnlyStrategy<DataType: RemoteDataModel>: FetchStrategy<DataType> {
    
    private let remoteRepository: RemoteRepository
    private let remoteRequest: RemoteRequest
    
    init(remoteRepository: RemoteRepository,
         remoteRequest: RemoteRequest) {
        self.remoteRepository = remoteRepository
        self.remoteRequest = remoteRequest
    }
    
    override func fetch() -> Observable<DataType> {
        return remoteRepository.request(remoteRequest)
    }
    
    override func fetch() -> Observable<[DataType]> {
        return remoteRepository.request(remoteRequest)
    }
}

class FetchCacheElseRemoteStrategy<DataType: DataModel>: FetchStrategy<DataType> {
    
    private let remoteRepository: RemoteRepository
    private let localRepository: LocalRepository
    private let remoteRequest: RemoteRequest
    private let localRequest: LocalRequest
    
    init(remoteRepository: RemoteRepository,
         localRepository: LocalRepository,
         remoteRequest: RemoteRequest,
         localRequest: LocalRequest) {
        self.remoteRepository = remoteRepository
        self.localRepository = localRepository
        self.remoteRequest = remoteRequest
        self.localRequest = localRequest
    }
    
    override func fetch() -> Observable<DataType> {
        let remoteStream: Observable<DataType> = remoteRepository.request(remoteRequest)
            .do(onNext: { data in
                self.localRepository.save(data, request: self.localRequest)
        })
        /// Local stream won't emit anything if there is no cache data
        let localStream: Observable<DataType> = localRepository.get(localRequest)
            .catchError { _ in remoteStream }
        return localStream
    }
    
    override func fetch() -> Observable<[DataType]> {
        /// Not support
        return .empty()
    }
}
