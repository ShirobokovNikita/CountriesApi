//
//  CustomCell.swift
//  CountriesApi
//
//  Created by Nikita Shirobokov on 28.11.22.
//

import UIKit
import SVGKit
import SnapKit

protocol Configurable {
    associatedtype Model
    
    func configure(model: Model)
}

class CustomCell: UITableViewCell, Configurable {
    
    typealias Model = Country
    
    private let fontSize: CGFloat = 32
    
    private lazy var countryImage: ImageView  = {
        let label = ImageView()
        return label
    }()
    
    private lazy var capitalLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: fontSize)
        return label
    }()
    
    private lazy var containerView: UIStackView = {
        let containerView = UIStackView(
            arrangedSubviews:
                [
                 countryLabel,
                 capitalLabel,
                 countryImage
                ]
        )
        containerView.axis = .vertical
//        containerView.distribution = .equalCentering
        
        return containerView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(model: Model) {
        
        self.countryLabel.text = model.name
        self.capitalLabel.text = model.capital
        
        countryImage.fetchImage(with: model.flag)
        
//        let image = model.flag
        
//        DispatchQueue.global().async {
//            guard let imageUrl = URL(string: image) else { return }
//            let request = URLRequest(url: imageUrl)
//
//            URLSession.shared.dataTask(with: request) { data, _, _ in
//                guard let imageData = data else { return }
//                let receivedSVG: SVGKImage = SVGKImage(data: imageData)
//                    DispatchQueue.main.async {
//                        self.countryImage.image = receivedSVG.uiImage
//                    }
//            }.resume()
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

