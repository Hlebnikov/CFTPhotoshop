//
//  Filters.swift
//  CFTPhotoshop
//
//  Created by Aleksandr X on 25.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import UIKit

protocol Filter {
  var name: String { get }
  func process(image: UIImage) -> Promise<UIImage>
}

private func launch(progress: @escaping (Double)->(), action: @escaping ()->Void) {
  let seconds = arc4random_uniform(25) + 5

  let queue = DispatchQueue(label: "filter", qos: .userInteractive)
  let ticTime = 0.5
  let tics = Int(Double(seconds)/ticTime)
  (1...tics).forEach({ (tic) in
    queue.asyncAfter(deadline: .now() + Double(tic) * ticTime, execute: {
      progress((100 - 100/Double(tic)) / 100)
    })
  })
  
  queue.asyncAfter(deadline: .now() + Double(seconds) + 0.1, execute: {
    action()
  })
}

class RotateFilter: Filter {
  var name: String = "rotate"
  
  func process(image: UIImage) -> Promise<UIImage> {
    return Promise() { progress, result in
      launch(progress: { value in
        progress(Float(value))
      }, action: {
        result(self.rotateImage(image) ?? image)
      })
    }
  }
  
  private func rotateImage(_ image: UIImage) -> UIImage? {
    let angle = CGFloat(Double.pi/2)
    let rotatedViewBox = UIView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
    let transform = CGAffineTransform(rotationAngle: angle)
    rotatedViewBox.transform = transform
    let rotatedSize = rotatedViewBox.frame.size
    
    UIGraphicsBeginImageContext(rotatedSize)
    guard let bitmap = UIGraphicsGetCurrentContext() else {
      return nil
    }
    bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
    bitmap.rotate(by: angle)
    bitmap.scaleBy(x: 1.0, y: -1.0)
    bitmap.draw(image.cgImage!, in: CGRect(x: -image.size.width / 2, y: -image.size.height / 2, width: image.size.width,height: image.size.height))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
}

class DesaturateFilter: Filter {
  var name: String = "desaturate"
  
  func process(image: UIImage) -> Promise<UIImage> {
    return Promise() { progress, result in
      launch(progress: { (progressTime) in
        progress(Float(progressTime))
      }, action: {
        let newimage = self.desaturate(image: image) ?? image
        progress(1)
        result(newimage)
      })
    }
  }
  
  private func desaturate(image: UIImage) -> UIImage? {
    let ciContext = CIContext(options: nil)
    let coreImage = CIImage(image: image)
    let filter = CIFilter(name: "CIPhotoEffectNoir" )
    filter?.setDefaults()
    filter?.setValue(coreImage, forKey: kCIInputImageKey)
    if let filteredImageData = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
      let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
      let resultImage = UIImage(cgImage: filteredImageRef!)
      return resultImage
    }
    return nil
  }
}

class InvertFilter: Filter {
  var name: String = "invert"
  
  func process(image: UIImage) -> Promise<UIImage> {
    return Promise() { progress, result in
      launch(progress: { value in
        progress(Float(value))
      }, action: {
        result(self.invert(image: image) ?? image)
      })
    }
  }
  
  private func invert(image: UIImage) -> UIImage{
    let ciContext = CIContext(options: nil)
    let coreImage = CIImage(image: image)
    let filter = CIFilter(name: "CIColorInvert" )
    filter!.setDefaults()
    filter!.setValue(coreImage, forKey: kCIInputImageKey)
    let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
    let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
    let resultImage = UIImage(cgImage: filteredImageRef!)
    return resultImage
  }

}

class ReflectFilter: Filter {
  var name: String = "reflect"
  
  func process(image: UIImage) -> Promise<UIImage> {
    return Promise<UIImage> { progress, result in
      launch(progress: { value in
        progress(Float(value))
      }, action: {
        result(self.reflect(image: image) ?? image)
      })
    }
  }
  
  private func reflect(image: UIImage) -> UIImage? {
    UIGraphicsBeginImageContext(image.size)
    let bitmap: CGContext = UIGraphicsGetCurrentContext()!
    bitmap.translateBy(x: image.size.width, y: image.size.height)
    bitmap.scaleBy(x: -image.scale, y: -image.scale)
    bitmap.draw(image.cgImage!, in: CGRect(origin: .zero, size: image.size))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
}
