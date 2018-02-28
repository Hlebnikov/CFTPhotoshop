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
  @IBOutlet weak var historyView: HistoryView!
  
  private var originalImage: UIImage? {
    didSet {
      pictureEditorView.image = originalImage
    }
  }
  private let imagePicker = UIImagePickerController()
  private let pictureEditor = PictureEditor()
  private let pictureLoader = PictureLoader()
  
  override func viewDidLoad() {
    pictureEditorView.setPresenter(self)
    historyView.hisoryKeeper = HistoryKeeper()
    historyView.delegate = self
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
    let downloadAction = UIAlertAction(title: "Download", style: .default) { [unowned self] _ in
      self.showDownloadAlert(withComplition: { (urlString) in
        self.pictureLoader
          .loadPicture(byUrl: urlString)
          .onComplete({ (image) in
            DispatchQueue.main.async {
              self.originalImage = image
            }
        })
      })
    }
    
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    imagePicker.allowsEditing = false
    alertController.addAction(photoLibraryAction)
    alertController.addAction(cameraAction)
    alertController.addAction(downloadAction)
    alertController.addAction(cancel)
    present(alertController, animated: true, completion: nil)
  }
  
  func desaturate() {
    applyFilter(type: .desaturate)
  }
  
  func rotate() {
    applyFilter(type: .rotate)
  }
  
  func reflect() {
    applyFilter(type: .reflect)
  }
  
  private func applyFilter(type: FilterType) {
    guard let image = originalImage else {
      print("Image not selected")
      return
    }
    
    self.historyView.addRecord(image: pictureEditor.applyFilter(type: type, forImage: image),
                               filterName: type.name)
  }
  
  private func showDownloadAlert(withComplition complition: @escaping (String) -> Void) {
    let alert = UIAlertController(title: "Paste url string", message: nil, preferredStyle: .alert)
    
    alert.addTextField { (textField) in
      textField.text = "https://i1.wp.com/chartcons.com/wp-content/uploads/Funny-Cat-Jokes2.jpg?resize=1021%2C576&ssl=1"
    }
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [unowned alert] (_) in
      let textField = alert.textFields!.first! // Force unwrapping because we know it exists.
      complition(textField.text ?? "")
    }))
    
    present(alert, animated: true, completion: nil)
  }
}

extension PictureEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      self.originalImage = pickedImage
    }
    
    dismiss(animated: true, completion: nil)
  }
}

extension PictureEditorViewController: HistoryViewDelegate {
  func historyView(_ hisoryView: HistoryView, didSelectImage image: UIImage) {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let editAction = UIAlertAction(title: "Edit", style: .default, handler: { _ in self.originalImage = image })
    let saveAction = UIAlertAction(title: "Save to Photo Album", style: .default) { _ in
      
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    alertController.addAction(editAction)
    alertController.addAction(saveAction)
    alertController.addAction(cancelAction)
    
    present(alertController, animated: true, completion: nil)
  }
}
