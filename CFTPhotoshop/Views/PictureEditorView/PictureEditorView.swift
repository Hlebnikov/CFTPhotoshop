//
//  PictureEditorView.swift
//  CFTPhotoshop
//
//  Created by Aleksandr X on 25.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import Foundation
import UIKit

protocol PictureEditorViewProtocol: class {
  var image: UIImage? { get set }
  func setPresenter(_ presenter: PictureEditorPresenterProtocol)
}

class PictureEditorView: XibDesignedView, PictureEditorViewProtocol {
  @IBOutlet private weak var openImageButton: UIButton!
  @IBOutlet private weak var imagePlace: UIImageView!
  
  private var presenter: PictureEditorPresenterProtocol?
  
  override var xibName: String {
    return "PictureEditorView"
  }
  
  var image: UIImage? {
    didSet {
      imagePlace.image = image
      openImageButton.isHidden = image != nil
    }
  }
  
  @IBAction private func onReflect(_ sender: Any) {
    presenter?.reflect()
  }
  
  @IBAction private func onRotate(_ sender: Any) {
    presenter?.rotate()
  }
  
  @IBAction private func onDesaturate(_ sender: Any) {
    presenter?.desaturate()
  }
  
  @IBAction private func onAddImage() {
    presenter?.getPicture()
  }
  
  @IBAction private func onInvertButton() {
    presenter?.invert()
  }
  
  func setPresenter(_ presenter: PictureEditorPresenterProtocol) {
    self.presenter = presenter
  }
  
}
