//
//  CityWeaterPresenter.swift
//  NAB
//
//  Created by Trung Luân on 8/23/20.
//  Copyright © 2020 LuanLT. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxOptional

protocol CityWeatherViewControllable: AnyObject {
    
    var viewState: BehaviorRelay<CityWeatherViewState> { get }
}

class CityWeatherPresenter: CityWeatherPresentable {
    
    // MARK: CityWeatherPresentable
    
    let viewDidLoadRelay = PublishRelay<Void>()
    let searchTextChangedRelay = PublishRelay<String?>()
    
    // MARK: Properties
    
    private weak var view: CityWeatherViewControllable?
    private let disposeBag = DisposeBag()
    private let service: CityWeatherService
    
    /// Searching
    private lazy var searchingScheduler = SerialDispatchQueueScheduler.init(internalSerialQueueName: "com.luanlt.nab.cityweather.serial")
    
    init(view: CityWeatherViewControllable,
         service: CityWeatherService) {
        self.view = view
        self.service = service
        configureStreams()
    }
    
    // MARK: Configurations
    
    private func configureStreams() {
        configureSearching()
    }
    
    private func configureSearching() {
        searchTextChangedRelay
            /// Only process if user stops typing for 0.5 seconds
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            /// Convert "Sài gòn" to "saigon"
            .map { $0?.searchKey() }
            .filterNil()
            .distinctUntilChanged()
            .do(onNext: { [weak self] _ in
                self?.view?.viewState.accept(.loading)
            })
            /// Only accept the result from latest search text
            .flatMapLatest({ [weak self] text -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.service.getWeather(city: text)
                    .flatMap { Observable.just($0) }
                    .materialize()
                    .map { [weak self] event in
                        self?.handleDataEvent(event)
                }
            })
            .subscribe(onNext: {})
            .disposed(by: disposeBag)
    }
    
    // MARK: Methods
    
    private func handleDataEvent(_ event: Event<CityWeather>) {
        switch event {
        case let .next(cityWeather):
            let viewData = cityWeather.toViewModel()
            view?.viewState.accept(.data(viewData))
        case let .error(error):
            view?.viewState.accept(.error(error))
        case .completed:
            break
        }
    }
}
