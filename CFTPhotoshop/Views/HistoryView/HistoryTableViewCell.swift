//
//  HistoryCellTableViewCell.swift
//  CFTPhotoshop
//
//  Created by Aleksandr X on 26.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
  static let xibName = "HistoryTableViewCell"
  
  @IBOutlet var progressViews: [UIProgressView]!
    
  @IBOutlet private weak var pictureImageView: UIImageView!
  @IBOutlet private weak var filterNameLabel: UILabel!
  @IBOutlet private weak var filterTitleLabel: UILabel!
  
  weak var presenter: HistoryTableCellPresenter? {
    willSet {
      presenter?.setCell(nil)
    }
    didSet {
      presenter?.setCell(self)
    }
  }
  
  private var loadingProgress: Float = 0.0 {
    didSet {
      progressViews.forEach({ $0.setProgress(loadingProgress, animated: true) })
    }
  }
  
  enum State {
    case loading(progress: Float)
    case show(image: UIImage, filterName: String)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    filterNameLabel.textColor = tintColor
    filterTitleLabel.textColor = tintColor
  }
  
  func set(state: State) {
    DispatchQueue.main.async {
      switch state {
      case .loading(progress: let progress):
        self.progressViews.forEach({ $0.isHidden = false })
        self.loadingProgress = progress
        self.pictureImageView.isHidden = true
        self.filterNameLabel.isHidden = true
        self.filterTitleLabel.isHidden = true
      case .show(image: let image, filterName: let filterName):
        self.progressViews.forEach({ $0.isHidden = true })
        self.pictureImageView.image = image
        self.filterNameLabel.text = filterName
        self.pictureImageView.isHidden = false
        self.filterNameLabel.isHidden = false
        self.filterTitleLabel.isHidden = false
      }
    }
  }
}
