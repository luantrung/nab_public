//
//  DefaultLocalRepository.swift
//
//  Created by Trung Luân on 5/19/20.
//

import Foundation
import RxSwift
import Cache

// MARK: DefaultLocalRepository

final class DefaultLocalRepository {
    
    private lazy var disposeBag = DisposeBag()
    private var storages = [String: Any]()
    
    init() {}
}

extension DefaultLocalRepository: LocalRepository {
    
    func save<T: LocalDataModel>(_ data: T, request: LocalRequest) {
        guard let storage: Storage<T> = makeStorage() else { return }
        guard case let .object(key) = request else { return }
        storages[key] = storage
        storage.async
            .setObject(data, key: key)
            .do(onCompleted: { [weak self] in
                self?.storages[key] = nil
            })
            .subscribe(onNext: {})
            .disposed(by: disposeBag)
    }
    
    func get<T: LocalDataModel>(_ request: LocalRequest) -> Observable<T> {
        guard let storage: Storage<T> = makeStorage() else { return .empty() }
        guard case let .object(key) = request else { return .empty() }
        storages[key] = storage
        return storage.async.object(key: key)
            .do(onCompleted: { [weak self] in
                self?.storages[key] = nil
            })
    }
}

// MARK: Cache

extension DefaultLocalRepository {
    
    private func makeStorage<T: Codable>() -> Storage<T>? {
        /// Expire in 1 day
        let diskConfig = DiskConfig(name: "city_weather",
                                    expiry: .seconds(86400))
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)
        
        do {
            let storage = try Storage(
                diskConfig: diskConfig,
                memoryConfig: memoryConfig,
                transformer: TransformerFactory.forData()
            )
            let transformedStorage = storage.transformCodable(ofType: T.self)
            return transformedStorage
        } catch {
            return nil
        }
    }
}
