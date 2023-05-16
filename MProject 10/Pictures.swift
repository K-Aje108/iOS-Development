//
//  Pictures.swift
//  MProject 10
//
//  Created by Kanyin Aje on 26/09/2020.
//

import UIKit

class Pictures: Codable {
    
    var image: String
    var caption: String
    
    
    init(image: String, caption: String) {
        self.image = image
        self.caption = caption
    }
    
}
