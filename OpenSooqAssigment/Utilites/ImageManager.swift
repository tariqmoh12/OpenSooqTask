//
//  ImageManager.swift
//  OpenSooqAssigment
//
//  Created by Tariq on 01/01/2024.
//

import UIKit

// MARK: - ImageLoader
class ImageLoader {
    static func loadImage(from url: URL, into imageView: UIImageView, placeholder: UIImage? = nil) {
        imageView.image = placeholder

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }.resume()
    }
}
