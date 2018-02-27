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
  
  @IBOutlet private weak var loader: UIActivityIndicatorView!
  @IBOutlet private weak var pictureImageView: UIImageView!
  @IBOutlet private weak var filterNameLabel: UILabel!
  @IBOutlet private weak var filterTitleLabel: UILabel!
  
  enum State {
    case loading(progress: Int)
    case show(image: UIImage, filterName: String)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    filterNameLabel.textColor = tintColor
    filterTitleLabel.textColor = tintColor
  }
  
  func set(state: State) {
    switch state {
    case .loading(progress: let _):
      if !loader.isAnimating {
        loader.startAnimating()
        pictureImageView.isHidden = true
        filterNameLabel.isHidden = true
        filterTitleLabel.isHidden = true
      }
    case .show(image: let image, filterName: let filterName):
      loader.stopAnimating()
      self.pictureImageView.image = image
      self.filterNameLabel.text = filterName
      pictureImageView.isHidden = false
      filterNameLabel.isHidden = false
      filterTitleLabel.isHidden = false
    }
  }

}
