//
//  PictureLoader.swift
//  CFTPhotoshop
//
//  Created by Aleksandr X on 28.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import UIKit

class PictureLoader {
  func loadPicture(byUrl urlString: String) -> Promise<UIImage> {
    return Promise<UIImage>(closure: { _, result in
      if let url = URL(string: urlString) {
        let downloadTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
          if let data = data, let image = UIImage(data: data) {
            result(image)
          }
        })
        
        downloadTask.resume()
      }
    })
  }
}
