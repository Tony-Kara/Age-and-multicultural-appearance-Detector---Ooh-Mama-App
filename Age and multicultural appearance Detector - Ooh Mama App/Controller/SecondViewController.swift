//
//  SecondViewController.swift
//  Age and multicultural appearance Detector - Ooh Mama App
//
//  Created by mac on 6/10/20.
//  Copyright © 2020 EniTony. All rights reserved.
//

import UIKit
import CLTypingLabel

class SecondViewController: UIViewController {
    var userImage: UIImage?
    var genderFromUser: String?
    var ageFromUser: Int?
    
    func ageFromUserInString() -> String {
        let agefromUserInstring = String(ageFromUser!)
        return agefromUserInstring
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView2.image = userImage
        genderlabel.text = "Gender:"
        ageLabel.text = "Age:"
        print(ageFromUser!) // fatal error here
        print(genderFromUser!) // fatal error here
       
        
          ageUser.text = ageFromUserInString()
          genderUser.text = genderFromUser
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        imageView2.applyshadowWithCorner(containerView: imgContainer, cornerRadius: 6)
    }
    
    @IBOutlet weak var imgContainer: UIView!
    @IBOutlet weak var ageUser: UILabel!
    @IBOutlet weak var genderUser: UILabel!
    @IBOutlet weak var imageView2: UIImageView!
    
    @IBOutlet weak var genderlabel: CLTypingLabel!
    
    @IBOutlet weak var ageLabel: CLTypingLabel!
    
}
