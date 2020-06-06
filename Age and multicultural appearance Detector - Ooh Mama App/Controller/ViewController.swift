//
//  ViewController.swift
//  Age and multicultural appearance Detector - Ooh Mama App
//
//  Created by mac on 6/4/20.
//  Copyright © 2020 EniTony. All rights reserved.
//

import UIKit
import YPImagePicker

class ViewController: UIViewController {
var config = YPImagePickerConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        config.isScrollToChangeModesEnabled = true
         config.onlySquareImagesFromCamera = true
         config.usesFrontCamera = false
         config.showsPhotoFilters = false
         config.showsVideoTrimmer = true
         config.shouldSaveNewPicturesToAlbum = true
         config.albumName = "DefaultYPImagePickerAlbumName"
         config.startOnScreen = YPPickerScreen.photo
         config.screens = [.library, .photo]
         config.showsCrop = .none
         config.targetImageSize = YPImageSize.original
         config.overlayView = UIView()
         config.hidesStatusBar = true
         config.hidesBottomBar = false
         config.preferredStatusBarStyle = UIStatusBarStyle.default
         config.bottomMenuItemSelectedTextColour = UIColor()
        config.bottomMenuItemUnSelectedTextColour = UIColor()
        // config.filters = [DefaultYPFilters...]
         config.maxCameraZoomFactor = 1.0
      
        
        
    }
    override func viewWillLayoutSubviews() {
        imageView1.applyshadowWithCorner(containerView: imgContainer, cornerRadius: 6)
    }
    @IBOutlet weak var UploadBtn: UIButton!
    
    @IBOutlet weak var pickBtn: UIButton!
    
    @IBOutlet weak var imageView1: UIImageView!
       
    @IBOutlet weak var imgContainer: UIView!
    
    @IBAction func pickBtnAction(_ sender: UIButton) {
        
        
           let picker = YPImagePicker(configuration: config)
           picker.didFinishPicking { [unowned picker] items, _ in
               if let photo = items.singlePhoto {
                   self.imageView1.contentMode = .scaleToFill
                   self.imageView1.image = photo.originalImage
                   
              
               }
               picker.dismiss(animated: true, completion: nil)
           }
          present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func uploadBtnAction(_ sender: UIButton) {
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
