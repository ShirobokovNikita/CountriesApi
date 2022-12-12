//
//  ICountryService.swift
//  CountriesApi
//
//  Created by Nikita Shirobokov on 29.11.22.
//

import UIKit

private extension String {
    static let countriesUrl = "https://restcountries.com/v2/all?fields=name,capital,region,subregion,population,area,nativeName,flag"
    static let countriesUrl2 = "https://jsonplaceholder.typicode.com/users"
}
    

enum CountryServiceError: String, Error {
    case nonValidUrl = "Неправильный URL адрес"
    case nonValidData = "Ошибка в загруженных данных"
    case decodeError = "Не удалось декодировать данные"
}

protocol ICountryService: AnyObject {
    func loadCountries(_ completion: @escaping (Result<[Country], Error>) -> Void)
}

class CountryService {}

extension CountryService: ICountryService {
    func loadCountries(_ completion: @escaping (Result<[Country], Error>) -> Void) {
        // СОЗДАНИЕ url запроса
        guard let url = URL(string: .countriesUrl) else {
            completion(.failure(CountryServiceError.nonValidUrl))
            return
        }
        // Создаем задачу в URLSession на выполнеие GET-запроса
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            // Проверяем ошибку от запроса
            if let error = error {
                completion(.failure(error))
                return
            }
            // Проверяем, пришли ли данные из запроса
            guard let data = data else {
                completion(.failure(CountryServiceError.nonValidData))
                return
            }
            // ДЕКОДИРОВАНИЕ (парсим JSON)
            let countries = try? JSONDecoder().decode([Country].self, from: data)
            if let countries = countries {
                completion(.success(countries))
            } else {
                completion(.failure(CountryServiceError.decodeError))
            }
            
        }.resume()
    }
}

