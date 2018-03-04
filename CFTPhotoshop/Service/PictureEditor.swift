//
//  PictureEditor.swift
//  CFTPhotoshop
//
//  Created by Aleksandr X on 25.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import UIKit

enum FilterType: Filter {
  case desaturate
  case rotate
  case reflect
  case invert
  
  var name: String {
    switch self {
    case .desaturate:
      return "Desaturate"
    case .reflect:
      return "Reflect"
    case .rotate:
      return "Rotate"
    case .invert:
      return "Invert"
    }
  }
  
  func process(image: UIImage) -> Promise<UIImage> {
    switch self {
    case .rotate:
      return RotateFilter().process(image: image)
    case .desaturate:
      return DesaturateFilter().process(image: image)
    case .reflect:
      return ReflectFilter().process(image: image)
    case .invert:
      return InvertFilter().process(image:image)
    }
  }
}

class PictureEditor {
  func applyFilter(type: FilterType, forImage image: UIImage) -> Promise<UIImage> {
    return type.process(image: image)
  }
}
