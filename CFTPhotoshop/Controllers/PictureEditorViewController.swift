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
  private var originalImage: UIImage?
  private let imagePicker = UIImagePickerController()
  
  override func viewDidLoad() {
    pictureEditorView.setPresenter(self)
    imagePicker.delegate = self
  }
}

extension PictureEditorViewController: PictureEditorPresenterProtocol {
  func getPicture() {
    let alertController = UIAlertController(title: "Image openning", message: nil, preferredStyle: .actionSheet)
    let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default) { [unowned self] _ in
      self.imagePicker.sourceType = .photoLibrary
      self.present(self.imagePicker, animated: true, completion: nil)
    }
    let cameraAction = UIAlertAction(title: "Camera", style: .default) { [unowned self] _ in
      self.imagePicker.sourceType = .camera
      self.present(self.imagePicker, animated: true, completion: nil)
    }
    imagePicker.allowsEditing = false
    alertController.addAction(photoLibraryAction)
    alertController.addAction(cameraAction)
    present(alertController, animated: true, completion: nil)
  }
  
  func desaturate() {
    
  }
  
  func rotate() {
    
  }
  
  func reflect() {
    
  }
}

extension PictureEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      pictureEditorView.image = pickedImage
      self.originalImage = pickedImage
    }
    
    dismiss(animated: true, completion: nil)
  }
}
