//
//  SecondViewController.swift
//  Age and multicultural appearance Detector - Ooh Mama App
//
//  Created by mac on 6/10/20.
//  Copyright © 2020 EniTony. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    var userImage: UIImage?
    var userGender: String?
    var userAge: Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView2.image = userImage
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var imageView2: UIImageView!
    
    @IBOutlet weak var genderlabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    
}
