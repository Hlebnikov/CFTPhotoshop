//
//  PictureEditorViewController.swift
//  CFTPhotoshop
//
//  Created by Aleksandr X on 25.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import UIKit

class PictureEditorViewController: UIViewController {
  @IBOutlet weak var pictureEditorView: PictureEditorView!
//  @IBOutlet weak var historyView: HistoryView!
  override func viewDidLoad() {
    pictureEditorView.setPresenter(self)
  }
}

extension PictureEditorViewController: PictureEditorPresenterProtocol {
  func getPicture() {
    
  }
  
  func desaturate() {
    
  }
  
  func rotate() {
    
  }
  
  func reflect() {
    
  }
}
