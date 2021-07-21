//
//  ResizeView.swift
//  Photo-Resizing-Filtering
//
//  Created by Sagar on 20/7/21.
//

import UIKit

protocol SavePhotoToLibraryDelegate: AnyObject {
    func getPhotoToSave(image : UIImage)
}

class ResizeView: UIView, UITextFieldDelegate {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var originalPhotoSizeLabel: UILabel!
    @IBOutlet weak var customWidthTextField: UITextField!
    @IBOutlet weak var customHeightTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var image : UIImage?
    var photoSize : CGSize?
    weak var delegate : SavePhotoToLibraryDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibsetup(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func nibsetup(frame : CGRect) {
        
        let nib = UINib(nibName: "ResizeView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = frame
        addSubview(contentView)
    }
    
    func processing() {
        setImageToImageView()
        setOriginalPhotoSizeDescription()
        setTextFields()
        
    }
    
    func setOriginalPhotoSizeDescription() {
        let photoWidth : Int = Int(photoSize!.width)
        let photoHeight : Int = Int(photoSize!.height)
        self.originalPhotoSizeLabel.text = "Original Size \(photoWidth) x \(photoHeight) pixel"
    }
    
    func setImageToImageView() {
        self.imageView.image = image
    }
    
    func setTextFields() {
        customWidthTextField.placeholder = "Width pixel"
        customWidthTextField.font = UIFont.systemFont(ofSize: 15)
        customWidthTextField.borderStyle = UITextField.BorderStyle.roundedRect
        customWidthTextField.autocorrectionType = UITextAutocorrectionType.no
        customWidthTextField.keyboardType = UIKeyboardType.default
        customWidthTextField.returnKeyType = UIReturnKeyType.done
        customWidthTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        customWidthTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        customWidthTextField.keyboardType = .numberPad
        customWidthTextField.delegate = self
        
        customHeightTextField.placeholder = "Height pixel"
        customHeightTextField.font = UIFont.systemFont(ofSize: 15)
        customHeightTextField.borderStyle = UITextField.BorderStyle.roundedRect
        customHeightTextField.autocorrectionType = UITextAutocorrectionType.no
        customHeightTextField.keyboardType = UIKeyboardType.default
        customHeightTextField.returnKeyType = UIReturnKeyType.done
        customHeightTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        customHeightTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        customHeightTextField.keyboardType = .numberPad
        customHeightTextField.delegate = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    @IBAction func saveButtonAction(_ sender: UIButton) {
        guard let widthValue = Int(customWidthTextField.text!), let heightValue = Int(customHeightTextField.text!) else {
            fatalError("SomeThing is wrong")
            // return
        }
        if(widthValue <= 0 || heightValue <= 0) {
            //            let alertController = UIAlertController(title: "Save error", message: "Width or Height value cannot be zero or negative", preferredStyle: .alert)
            //            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            return
        }
        let resizedImage : UIImage? = self.resizeImage(image: self.image!, newWidth: widthValue, newHeight: heightValue)!
        if resizedImage != nil {
            delegate?.getPhotoToSave(image: resizedImage!)
        }
    }
    
    func resizeImage(image: UIImage, newWidth: Int, newHeight : Int) -> UIImage? {
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func textFieldBeganEndEditing(_ textField: UITextField) {
        print("text field began editing called")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("text field end editing called")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == self.customWidthTextField) {
            self.customHeightTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}

