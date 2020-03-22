//
//  String+UIImage.swift
//  ImageEditing
//
//  Created by Ihor Vovk on 21.03.2020.
//  Copyright © 2020 Ihor Vovk. All rights reserved.
//

import UIKit

extension String {
    
    func image() -> UIImage? {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        
        (self as AnyObject).draw(in: CGRect(origin: .zero, size: size), withAttributes: [.font: UIFont.systemFont(ofSize: 80)])
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
