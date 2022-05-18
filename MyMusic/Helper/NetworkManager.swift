//
//  NetworkManager.swift
//  MyMusic
//
//  Created by Tarun Kaushik on 07/11/20.
//

import Foundation
import UIKit

class NetworkManager {
    
    private init(){}
    static let shared = NetworkManager()
    private let imageCache = NSCache<NSString,UIImage>()
    
    func downloadImage(url: URL, completion: @escaping(_ image: UIImage?,_ error: Error?) -> Void){
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString ) {
            completion(cachedImage, nil)
        } else {
            let session = URLSession.shared
            
            let request = URLRequest(url: url)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error{
                    completion(nil, AppError.misc(error.localizedDescription))
                } else if let data = data {
                    if let image = UIImage(data: data) {
                        self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                        completion(image, nil)
                    }
                } else {
                    completion(nil,AppError.misc(error?.localizedDescription ?? "Something went wrong!"))
                }
            }
            
            task.resume()
        }
    }
}
