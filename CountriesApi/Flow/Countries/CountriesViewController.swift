//
//  CountriesViewController.swift
//  CountriesApi
//
//  Created by Nikita Shirobokov on 28.11.22.
//

import UIKit
import SnapKit

private extension CGFloat {
    static let loaderDimention: CGFloat = 64
}

private extension String {
    static let cellReuseIdentifier = "CountryCell"
}

protocol ICountriesView: AnyObject {
    func showErrorAlert(_ message: String)
    func startLoader()
    func stopLoader()
}

class CountriesViewController: UIViewController {
    
    private let alertFactory: ICountriesAlertViewFactory
    
    private let output: ICountriesPresentor?
    
    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.style = .large
        loader.color = .yellow
        return loader
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomCell.self, forCellReuseIdentifier: .cellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        return tableView
    }()
    
    init(alertFactory: ICountriesAlertViewFactory, output: ICountriesPresentor) {
        self.output = output
        self.alertFactory = alertFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // override func viewDidLoad() запустится при загрузке экрана, вызовится UIKit`ом
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 200
        setupLoader()
        setUpTableView()
        
        output?.viewDidLoad()
    }
    
    //MARK: - Private
    
    private func setupLoader() {
        view.addSubview(loader)
        loader.snp.makeConstraints { make in
            make.size.equalTo(CGFloat.loaderDimention)
            make.center.equalToSuperview()
        }
    }
    
    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            // левую и правую сторону прикрепляем к Superview
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
    
    // MARK: - ICountriesView
    
    extension CountriesViewController: ICountriesView {
        func showErrorAlert(_ message: String) {
            // Создаем Alert с кодом ошибки message, и при нажатии на клавишу [weak self] будет происходить dismiss(убирать этот экран)
            let alert = alertFactory.makeAlert(with: message) { [weak self] in
                self?.dismiss(animated: true)
            }
            present(alert, animated: true)
        }
        
        func startLoader() {
            loader.startAnimating()
            tableView.isHidden = true
        }
        func stopLoader() {
            loader.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
        }
    }

// MARK: - UITableViewDelegate

extension CountriesViewController: UITableViewDelegate {
}

// MARK: - UITableViewDataSource

extension CountriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .cellReuseIdentifier, for: indexPath)
        if let item = output?.getItem(for: indexPath.row) {
            (cell as? CustomCell)?.configure(model: item)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output?.numberOfRows ?? .zero
    }
}

