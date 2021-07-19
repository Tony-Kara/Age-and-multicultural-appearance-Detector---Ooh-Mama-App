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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
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
        
        textOnUploadPicture.isHidden = false
        //actInd.isHidden = false
        actInd.hidesWhenStopped = true
    }
    
    // var uservalues: UserValues?
    
    var image1: UIImage?
    var Gender: String?
    var Age: Int?
    
    //let queue = DispatchQueue(label: "tony", attributes: .concurrent)
    let dispatchGroup = DispatchGroup()
   
    
    override func viewWillLayoutSubviews() {
        imageView1.applyshadowWithCorner(containerView: imgContainer, cornerRadius: 6)
    }
    
    
    
    @IBOutlet weak var actInd: UIActivityIndicatorView!
    @IBOutlet weak var textOnUploadPicture: UILabel!
    @IBOutlet weak var imageView1: UIImageView!
    
    @IBOutlet weak var imgContainer: UIView!
    
    @IBAction func pickBtnAction(_ sender: UIButton) {
        
       let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.imageView1.contentMode = .scaleToFill
                self.imageView1.image = photo.originalImage
                self.image1 = photo.originalImage
                self.textOnUploadPicture.isHidden = true
                
            }
            picker.dismiss(animated: true, completion: nil)
        }
            present(picker, animated: true, completion: nil)
        
       
    }
    
    @IBAction func uploadBtnAction(_ sender: UIButton) {
    
        let imageOfUser = UIImage(named: "\(imageView1.image!)")
        if  imageOfUser != nil{
        actInd.startAnimating()
        dispatchGroup.enter()
        dispatchGroup.enter()
        checkFofGender(in: dispatchGroup)
        checkForAge(in: dispatchGroup)
        
        dispatchGroup.notify(queue: .main){
            self.actInd.stopAnimating()
            self.performSegue(withIdentifier: "updates", sender: self)
            
        }
        }
        
        else{textOnUploadPicture.text = "Click on the Pick button!"}
        
        
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updates" {
            let destinationVC = segue.destination as! SecondViewController
            destinationVC.userImage = image1
            destinationVC.genderFromUser = Gender
            destinationVC.ageFromUser = Age
        }
    }
    
    
    func checkFofGender(in myGroup: DispatchGroup) {
        
        NetworkServices.instance.getGender(image: imageView1.image!) { [weak self] (gender) in
            guard let self = self else { return }
            self.Gender = gender
            myGroup.leave()
        }
    }
    func checkForAge(in myGroup: DispatchGroup) {
        
        NetworkServices.instance.getAge(image: self.imageView1.image!) { [weak self]  (age) in
            guard let self = self else { return }
            self.Age = age
            
            myGroup.leave()
        }
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
