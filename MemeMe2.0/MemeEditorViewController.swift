//
//  ViewController.swift
//  MemeMe2.0
//
//  Created by Rita Dewi on 13/11/2018.
//  Copyright © 2018 RitaDewi. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField(topTextField, text: "TOP")
        configureTextField(bottomTextField, text: "BOTTOM")
        imagePickerView.image = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = imagePickerView.image != nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickImageFromPhotoAlbum(_ sender: Any) {
        pickImageSourceType(.photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        pickImageSourceType(.camera)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        if shareButton.isEnabled {
            let imageToShare = generateMemedImage()
            let controller = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
            self.present(controller, animated: true, completion: nil)
            
            controller.completionWithItemsHandler = {
                (activityType, completed, returnedItems, activityError) in
                if completed {
                    self.save()
                    self.viewDidLoad()
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    //Declare dictionary here and used directly
    let memeTextAttribute: [String: Any] = [NSAttributedStringKey.strokeColor.rawValue: UIColor.black, NSAttributedStringKey.foregroundColor.rawValue: UIColor.white, NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, NSAttributedStringKey.strokeWidth.rawValue: -4.0
    ]
}

//MARK: - Text Field Related Methods
extension MemeEditorViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if bottomTextField.isFirstResponder {
            subscribeToKeyboardNotifications()
        }
        
        //Text will not be emptied just in case user needs to re-edit
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
        
        for eachTextField in getTextField() {
            eachTextField.defaultTextAttributes = memeTextAttribute
            eachTextField.textAlignment = .center
        }
    }
    
    //Function to get all existing text fields
    func getTextField() -> [UITextField] {
        var existingTextField = [UITextField]()
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                existingTextField += [textField]
            }
        }
        return existingTextField
    }
    
    //Put configuration for both text fields here
    func configureTextField(_ tf: UITextField, text: String) {
        tf.text = text
        tf.textAlignment = .center
        tf.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        subscribeToKeyboardWillHideNotifications()
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - Taking, Saving, Sharing Pictures Related Methods
extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = imagePicked
            imagePickerView.contentMode = .scaleAspectFit
        }
        dismiss(animated: true, completion: nil)
    }
    
    func pickImageSourceType(_ pickerSourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = pickerSourceType
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y = 0
        if !topTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    func subscribeToKeyboardWillHideNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        UIImageWriteToSavedPhotosAlbum(meme.memedImage!, nil, nil, nil)
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        self.toolBar.isHidden = true
        self.navigationBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.toolBar.isHidden = false
        self.navigationBar.isHidden = false
        
        return memedImage
    }
}
