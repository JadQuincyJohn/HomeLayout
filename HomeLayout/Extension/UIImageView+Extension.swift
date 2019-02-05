//
//  UIImageView+Extension.swift
//  HomeLayout
//
//  Created by Jad Abi-Abdallah on 05/02/2019.
//  Copyright © 2019 Jad Abi-Abdallah. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func cacheImage(urlString: String) {
        
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data)
                    imageCache.setObject(imageToCache!, forKey: urlString as NSString)
                    self.image = imageToCache
                }
            }
        }
        dataTask.resume()
    }
}
