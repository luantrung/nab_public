//
//  CityWeatherViewController.swift
//  NAB
//
//  Created by Trung Luân on 8/22/20.
//  Copyright © 2020 LuanLT. All rights reserved.
//

import UIKit
import RxSwift
import Reusable
import RxRelay
import RxDataSources
import StatefulViewController

typealias CityWeatherViewState = ViewState<[CityWeatherSectionModel]>

protocol CityWeatherPresentable: AnyObject {
    
    var viewDidLoadRelay: PublishRelay<Void> { get }
    var searchTextChangedRelay: PublishRelay<String?> { get }
}

class CityWeatherViewController: UIViewController, StoryboardBased, CityWeatherViewControllable {
    
    // MARK: Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    private var searchViewController: UISearchController?
    
    // MARK: Properties
    
    var presenter: CityWeatherPresentable?
    let viewState = BehaviorRelay<CityWeatherViewState>(value: .data([]))
    private lazy var dataSource: CityWeatherDataSource = self.makeDatasource()
    private let disposeBag = DisposeBag()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defer { presenter?.viewDidLoadRelay.accept(()) }
        configureView()
        configurePresenter()
    }
    
    // MARK: Configurations
    
    private func configureView() {
        navigationItem.title = NSLocalizedString("Weather Forecast", comment: "City weather view title")
        /// Search Bar
        searchViewController = UISearchController()
        searchViewController?.hidesNavigationBarDuringPresentation = false
        searchViewController?.obscuresBackgroundDuringPresentation = false
        searchViewController?.searchBar.delegate = self
        navigationItem.searchController = searchViewController
        
        /// Table
        tableView.tableFooterView = UIView(frame: .zero)
        
        /// Register nibs
        tableView.register(cellType: CityWeatherTableViewCell.self)
        
        configureStateView()
    }
    
    private func configurePresenter() {
        viewState
            .do(onNext: { [weak self] state in
                self?.updateViewState(state)
            })
            .map { state -> [CityWeatherSectionModel] in
                switch state {
                case let .data(data):
                    return data
                default:
                    return []
                }
        }
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    }
    
    // MARK: Datasource
    
    private func makeDatasource() -> CityWeatherDataSource {
        let customAnimation = AnimationConfiguration(insertAnimation: .fade,
                                                     reloadAnimation: .fade,
                                                     deleteAnimation: .fade)
        return CityWeatherDataSource(animationConfiguration: customAnimation,
                                     configureCell: { _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CityWeatherTableViewCell.self)
            cell.update(data: item)
            return cell
        })
    }
}

// MARK: UISearchBarDelegate

extension CityWeatherViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchTextChangedRelay.accept(searchText)
    }
}

// MARK: StatefulViewController

extension CityWeatherViewController: StatefulViewController {
    
    private func configureStateView() {
        let loadingLabel = makeStateLabel()
        loadingLabel.text = NSLocalizedString("Loading", comment: "")
        loadingView = loadingLabel
        
        let errorLabel = makeStateLabel()
        errorLabel.text = NSLocalizedString("Error", comment: "")
        errorView = errorLabel
        
        let emptyLabel = makeStateLabel()
        emptyLabel.text = NSLocalizedString("No data", comment: "")
        emptyView = emptyLabel
    }
    
    private func makeStateLabel() -> UILabel {
        let stateLabel = UILabel()
        stateLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        stateLabel.numberOfLines = 0
        stateLabel.textAlignment = .center
        return stateLabel
    }
    
    private func updateViewState(_ state: CityWeatherViewState) {
        switch state {
        case let .error(error):
            endLoading(error: error)
            (errorView as? UILabel)?.text = error.localizedDescription
        case .loading:
            startLoading()
        case .empty:
            endLoading()
        case .data(_):
            endLoading()
        }
    }
    
    func hasContent() -> Bool {
        switch viewState.value {
        case let .data(data):
            return data.isNotEmpty
        default:
            return false
        }
    }
}
