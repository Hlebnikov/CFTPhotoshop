//
//  Promise.swift
//  CFTPhotoshop
//
//  Created by Aleksandr X on 25.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import Foundation

class Promise<T> {
  private var onProgress: ((Float) -> Void) = {_ in }
  private var onComplete: ((T) -> Void) = {_ in }
  private var closure: (_ progress: @escaping (Float) -> Void, _ complete: @escaping (T) -> Void) -> Void
  
  init(closure: @escaping (_ progress: @escaping (Float) -> Void, _ complete: @escaping (T) -> Void) -> Void) {
    self.closure = closure
  }
  
  func onProgress(_ onProgress: @escaping ((Float) -> Void)) -> Self {
    self.onProgress = onProgress
    return self
  }
  
  func onComplete(_ onComplete: @escaping ((T) -> Void)) {
    self.onComplete = onComplete
    self.run()
  }
  
  private func run() {
    closure({ (progress) in
      self.onProgress(progress)
    }) { (result) in
      self.onComplete(result)
    }
  }
  
}
