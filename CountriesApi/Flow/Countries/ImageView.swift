//
//  ImageView.swift
//  CountriesApi
//
//  Created by Nikita Shirobokov on 11.12.22.
//

import UIKit
import SVGKit

class ImageView: UIImageView {
    
    func fetchImage(with url: String) {
        guard let imageURL = url.getURL() else {
            // сюда нужно поместить заглушку
            image = UIImage(imageLiteralResourceName: "picture")
            return
        }
        
        // если изображение есть в кэш, то используем его
        if let cachedImage = getCachedImage(url: imageURL) {
            image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: imageURL) { data, responce, error in
            
            if let error = error { print(error); return }
            guard let data = data, let responce = responce else { return }
            guard let responceURL = responce.url else { return }
            
            if responceURL.absoluteString != url { return }
            let receivedSVG: SVGKImage = SVGKImage(data: data)
            
            DispatchQueue.main.async {
                self.image = receivedSVG.uiImage
            }
            
            // Сохраняем изображение в кэш
            self.saveImageToCache(data: data, responce: responce)
            
        }.resume()
    }
    
    private func saveImageToCache(data: Data, responce: URLResponse) {
        guard let responceURL = responce.url else { return }
        let cachedResponce = CachedURLResponse(response: responce, data: data)
        URLCache.shared.storeCachedResponse(cachedResponce, for: URLRequest(url: responceURL))
        
    }
    
    private func getCachedImage(url: URL) -> UIImage? {
        if let cacheResponce = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            let receivedSVG: SVGKImage = SVGKImage(data: cacheResponce.data)
            return receivedSVG.uiImage
        }
        return nil
    }
}

fileprivate extension String {
    
    func getURL() -> URL? {
        guard let url = URL(string: self) else { return nil }
        return url
    }
}

