//
//  PictureEditor.swift
//  CFTPhotoshop
//
//  Created by Aleksandr X on 25.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import UIKit

enum FilterType {
  case desaturate
  case rotate
  case reflect
}

class PictureEditor {
  func applyFilter(type: FilterType, forImage image: UIImage) -> Promise<UIImage> {
    
    switch type {
    case .rotate:
      return RotateFilter().process(image: image)
    case .desaturate:
      return DesaturateFilter().process(image: image)
    case .reflect:
      return ReflectFilter().process(image: image)
    }
  }
}
