//
//  CountriesViewDataSource.swift
//  CountriesApi
//
//  Created by Nikita Shirobokov on 29.11.22.
//

import Foundation

// MARK: ИМИТАЦИЯ КЭША

protocol ICountriesViewDataSource: AnyObject {
    func save(_ items: [Country])
    func getCoutry(at index: Int) -> Country
    
    var itemsCount: Int { get }
}

class CountriesViewDataSource: ICountriesViewDataSource {
    private var items: [Country] = []
    
    var itemsCount: Int {
        items.count
    }
    
    func getCoutry(at index: Int) -> Country {
        items[index]
    }
    
    func save(_ items: [Country]) {
        self.items = items
    }
}
