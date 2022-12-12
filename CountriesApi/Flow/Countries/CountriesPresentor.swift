//
//  CountriesPresentor.swift
//  CountriesApi
//
//  Created by Nikita Shirobokov on 29.11.22.
//

import Foundation

private extension String {
    static let defaultError = "Произошла ошибка"
}

protocol ICountriesPresentor: AnyObject {
    func viewDidLoad()
    func getItem(for index: Int) -> Country
    var numberOfRows: Int { get }
}

class CountriesPresentor {
    private let service: ICountryService
    private let dataSource: ICountriesViewDataSource
    weak var view: ICountriesView?
    
    var numberOfRows: Int {
        dataSource.itemsCount
    }
    
    init(service: ICountryService,
         dataSource: ICountriesViewDataSource
    ) {
        self.service = service
        self.dataSource = dataSource
    }
}

// MARK: ICountriesPresentor

extension CountriesPresentor: ICountriesPresentor {
    func viewDidLoad() {
        view?.startLoader()
        service.loadCountries { [weak self] result in
            switch result {
            case let .success(countries):
                self?.dataSource.save(countries)
            // Ошибка на стороне presentor`a
            case let .failure(error):
                if let serviceError = error as? CountryServiceError {
                    DispatchQueue.main.async {
                        self?.view?.showErrorAlert(serviceError.rawValue)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.view?.showErrorAlert(.defaultError)
                    }
                }
            }
            DispatchQueue.main.async {
                self?.view?.stopLoader()
            }
        }
    }
    
    func getItem(for index: Int) -> Country {
        dataSource.getCoutry(at: index)
    }
}
