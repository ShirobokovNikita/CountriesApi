//
//  CountriesAlertViewFactory.swift
//  CountriesApi
//
//  Created by Nikita Shirobokov on 30.11.22.
//

import Foundation
import UIKit

private extension String {
    static let showError = "Произошла ошибка"
    static let okButtonTitle = "OK"
}

protocol ICountriesAlertViewFactory: AnyObject {
    func makeAlert(with message: String, onTap: @escaping () -> Void) -> UIAlertController
}

class CountriesAlertViewFactory {}

// MARK: - ICountriesAlertViewFactory

extension CountriesAlertViewFactory: ICountriesAlertViewFactory {
    func makeAlert(with message: String, onTap: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: .showError, message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: .okButtonTitle,
                style: .cancel,
                handler: { _ in onTap() }
            )
        )
        return alert
    }
}
