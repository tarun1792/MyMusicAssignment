//
//  Extension.swift
//  MyMusic
//
//  Created by Tarun Kaushik on 07/11/20.
//

import Foundation

import Foundation
import UIKit

extension UIImageView{
    
    func downloadImage(url: String?,placeHolder: UIImage? = nil){
        guard let urlString = url else { return }
        guard let url = URL(string: urlString) else { return }
        
        NetworkManager.shared.downloadImage(url: url) { (image, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                }
            }
        }
    }
}
