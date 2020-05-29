//
//  AsyncImageView.swift
//  Social.ly
//
//  Created by Jordan Bryant on 2/11/20.
//  Copyright © 2020 Jordan Bryant. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class AsyncImageView: UIImageView {
    
    var imageUrlString: NSString?
    
    func loadImageUsingUrlString(urlString: NSString) {
        
        imageUrlString = urlString
        
        guard let url = URL(string: urlString as String) else { image = nil; return }
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString) {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
            
            if error != nil {
                print(error?.localizedDescription ?? "")
                return
            }
            
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                
                if let imageToCache = imageToCache {
                    imageCache.setObject(imageToCache, forKey: urlString)
                }
            }
            
        }).resume()
    }
    
}
