//
//  RenderedImageViewController.swift
//  ImageEditing
//
//  Created by Ihor Vovk on 21.03.2020.
//  Copyright © 2020 Ihor Vovk. All rights reserved.
//

import UIKit

class RenderedImageViewController: UIViewController {

    var renderedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = renderedImage
    }
    
    // MARK: - Implementation
    
    @IBOutlet private weak var imageView: UIImageView!
}
