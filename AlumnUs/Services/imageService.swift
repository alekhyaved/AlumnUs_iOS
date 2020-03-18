//
//  imageService.swift
//  AlumnUs
//
//  Created by Juhi Nayak on 3/17/20.
//  Copyright © 2020 Juhi Nayak. All rights reserved.
//

import Foundation
import UIKit

class imageService{
    
    static let cache = NSCache<NSString, UIImage>()
    
    static func downloadImage(withURL url: URL, completion: @escaping (_ image: UIImage?)->()){
        
        
        let dataTask = URLSession.shared.dataTask(with: url){ data, responseurl, error in
            
            var downloadImage:UIImage?
            
            if let data = data{
                downloadImage = UIImage(data: data)
            }
            
            if downloadImage != nil{
                cache.setObject(downloadImage!, forKey: url.absoluteString as NSString)
            }
            DispatchQueue.main.async {
                completion(downloadImage)
            }
            
        }
        dataTask.resume()
    }
    
    static func getImage (withURL url: URL, completion: @escaping (_ image: UIImage?)->()){
        
        if let image = cache.object(forKey: url.absoluteString as NSString){
            completion(image)
        }
        else{
            downloadImage(withURL: url, completion: completion)
        }
        
        
        
    }
}
