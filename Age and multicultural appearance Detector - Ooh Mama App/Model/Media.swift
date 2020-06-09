//
//  Media.swift
//  Age and multicultural appearance Detector - Ooh Mama App
//
//  Created by mac on 6/7/20.
//  Copyright © 2020 EniTony. All rights reserved.
//

import UIKit
struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "eniTony.jpg"
        
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil } //image which is in jpeg format is converted to data
        self.data = data
    }
    
}
