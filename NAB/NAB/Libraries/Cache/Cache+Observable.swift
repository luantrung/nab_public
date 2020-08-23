//
//  Cache+Observable.swift
//  NAB
//
//  Created by Trung Luân on 8/22/20.
//  Copyright © 2020 LuanLT. All rights reserved.
//

import Foundation
import RxSwift
import Cache

typealias CacheCompletion<T> = (Cache.Result<T>) -> Void

extension AsyncStorage {
    
    func setObject(_ object: T, key: String) -> Observable<Void> {
        let saveObservable: Observable<Void> = observable { [unowned self] completion in
            self.setObject(object, forKey: key, completion: completion)
        }
        return saveObservable
    }
    
    func object(key: String) -> Observable<T> {
        return observable { [weak self] completion in
            self?.removeExpiredObjects { _ in
                self?.object(forKey: key, completion: completion)
            }
        }
    }
}

/**
Convert closure to observable
 */
private func observable<T>(from closure: @escaping (_ completion: @escaping CacheCompletion<T>) -> Void) -> Observable<T> {
    return Observable.create { observer in
        closure { value in
            switch value {
            case let .value(value):
                observer.onNext(value)
            case let .error(error):
                observer.onError(error)
            }
            observer.onCompleted()
        }
        return Disposables.create {}
    }
}
