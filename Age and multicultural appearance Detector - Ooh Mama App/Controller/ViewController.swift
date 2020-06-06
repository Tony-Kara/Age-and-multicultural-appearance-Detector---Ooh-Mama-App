//
//  ViewController.swift
//  Age and multicultural appearance Detector - Ooh Mama App
//
//  Created by mac on 6/4/20.
//  Copyright © 2020 EniTony. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
let pickerController = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
      pickerController.delegate = self
        
        
    }
    override func viewWillLayoutSubviews() {
        imageView1.applyshadowWithCorner(containerView: imgContainer, cornerRadius: 6)
    }
    @IBOutlet weak var UploadBtn: UIButton!
    
    @IBOutlet weak var pickBtn: UIButton!
    
    @IBOutlet weak var imageView1: UIImageView!
       
    @IBOutlet weak var imgContainer: UIView!
    
     
       
       @IBAction func imageView(_ sender: UIButton) {
           let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
           alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
               self.openCamera()
           }))

           alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
               self.openGallery()
           }))

           alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

           self.present(alert, animated: true, completion: nil)
           
           
       }
       
      func openCamera()
      {
          if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
              let imagePicker = UIImagePickerController()
              imagePicker.delegate = self
              imagePicker.sourceType = UIImagePickerController.SourceType.camera
              imagePicker.allowsEditing = false
              self.present(imagePicker, animated: true, completion: nil)
          }
          else
          {
              let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
              self.present(alert, animated: true, completion: nil)
          }
      }
       
       
       
        func openGallery()
       {
           if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
               let imagePicker = UIImagePickerController()
               imagePicker.delegate = self
               imagePicker.allowsEditing = true
               imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
               self.present(imagePicker, animated: true, completion: nil)
           }
           else
           {
               let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               self.present(alert, animated: true, completion: nil)
           }
       }
       
       //MARK:-- ImagePicker delegate
           func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let pickedImage = info[.originalImage] as? UIImage {
               imageView1.contentMode = .scaleToFill
               imageView1.image = pickedImage
               
             
               
           }
           picker.dismiss(animated: true, completion: nil)
       }

       
      


       
}

extension UIImageView {
func applyshadowWithCorner(containerView : UIView, cornerRadius : CGFloat){
    containerView.clipsToBounds = false
    containerView.layer.shadowColor = UIColor.darkGray.cgColor
    containerView.layer.shadowOpacity = 1
    containerView.layer.shadowOffset = CGSize.zero
    containerView.layer.shadowRadius = 3
    containerView.layer.cornerRadius = cornerRadius
    containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadius).cgPath
    self.clipsToBounds = true
    self.layer.cornerRadius = cornerRadius
}
}
