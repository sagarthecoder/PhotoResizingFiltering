//
//  HomeViewController.swift
//  Photo-Resizing-Filtering
//
//  Created by Sagar on 20/7/21.
//

import UIKit
import Photos
import CoreServices

class HomeViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, SavePhotoToLibraryDelegate {

    @IBOutlet weak var photoResizingButton: UIButton!
    
    @IBOutlet weak var photoFilteringButton: UIButton!
    
    @IBOutlet weak var storeView: UIView!
    
    let imagePickerController = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello home")
        photoResizingButton.isSelected = false
        photoFilteringButton.isSelected = false
        storeView.backgroundColor = .clear
        // Do any additional setup after loading the view.
    }
    
    
    func setImagePickerProperties() {
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = [kUTTypeImage as String]
    }
    @IBAction func photoResizingButtonAction(_ sender: UIButton) {
        photoResizingButton.isSelected = true
        photoFilteringButton.isSelected = false
        self.setImagePickerProperties()
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func photoFilteringButtonAction(_ sender: Any) {
        photoResizingButton.isSelected = false
        photoFilteringButton.isSelected = true
        self.setImagePickerProperties()
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        //DispatchQueue.global(qos: .userInitiated).async {
          //  DispatchQueue.main.async {
                if(self.photoResizingButton.isSelected) {
                    self.setResizeViewAsSubView(selectedImage: selectedImage)
                } else if(self.photoFilteringButton.isSelected) {
                    self.setFilterViewAsSubView(selectedImage: selectedImage)
                }
          //  }
        //}
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    private func setResizeViewAsSubView(selectedImage : UIImage) {
        self.removeAllSubViews()
        let resizeView = ResizeView(frame: self.storeView.bounds)
        resizeView.image = selectedImage
        resizeView.photoSize = selectedImage.size
        resizeView.delegate = self
        resizeView.processing()
        resizeView.layoutIfNeeded()
        self.storeView.addSubview(resizeView)
    }
    
    private func setFilterViewAsSubView(selectedImage : UIImage) {
        self.removeAllSubViews()
    }
    
    private func removeAllSubViews() {
        for view in self.storeView.subviews {
            view.removeFromSuperview()
        }
    }
    
    func getPhotoToSave(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(savePhotoToLibrary(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func savePhotoToLibrary(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alertController = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        } else {
            let alertController = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        }
    }

}
