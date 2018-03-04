//
//  HistoryTableCellPresenter.swift
//  CFTPhotoshop
//
//  Created by Aleksandr X on 04.03.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import Foundation
import UIKit

protocol HistoryCellPresenterDelegate: class {
  func historyCellPresenter(_ cellPresenter: HistoryTableCellPresenter, didCompleteLoadImageWithResult result: EditResult)
}

class HistoryTableCellPresenter {
  private weak var cell: HistoryTableViewCell?
  var state: HistoryTableViewCell.State? {
    didSet {
      guard let state = state else {
        return
      }
      
      switch state {
      case .show(image: _, filterName: let filterName):
        self.filterName = filterName
      default:
        break
      }
    }
  }
  var filterName: String = ""
  
  weak var delegate: HistoryCellPresenterDelegate?
  
  private var imagePromise: Promise<UIImage>? {
    didSet {
      if let promise = imagePromise {
        self.state = .loading(progress: 0)
        promise
          .onProgress({[unowned self] (progress) in
            self.state = .loading(progress: progress)
            self.cell?.set(state: self.state!)
          })
          .onComplete {[unowned self] (image) in
            let editResult = EditResult(id: nil, image: image, filterName: self.filterName)
            self.delegate?.historyCellPresenter(self, didCompleteLoadImageWithResult: editResult)
            
            self.state = .show(image: image, filterName: self.filterName)
            self.cell?.set(state: self.state!)
            self.imagePromise = nil
        }
      }
    }
  }
  
  func update(withPromise promise: Promise<UIImage>, filterName: String) {
    imagePromise = promise
    self.filterName = filterName
  }
  
  func setCell(_ cell: HistoryTableViewCell?) {
    self.cell = cell
    if let state = state {
      cell?.set(state: state)
    }
  }
}
