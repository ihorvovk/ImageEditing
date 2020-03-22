//
//  EditingViewController.swift
//  ImageEditing
//
//  Created by Ihor Vovk on 21.03.2020.
//  Copyright © 2020 Ihor Vovk. All rights reserved.
//

import UIKit

class EditingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "render", let destinationVC = segue.destination as? RenderedImageViewController {
            destinationVC.renderedImage = renderToImage()
        }
    }

    // MARK: - Implementation
    
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!

    @IBOutlet private var panGestureRecognizer: UIPanGestureRecognizer!
    @IBOutlet private var pinchGestureRecognizer: UIPinchGestureRecognizer!
    @IBOutlet private var rotationGestureRecognizer: UIRotationGestureRecognizer!
    
    private var emojiImageView: UIImageView?
    private var emojiPanGestureRecognizer: UIPanGestureRecognizer?
    private var emojiPinchGestureRecognizer: UIPinchGestureRecognizer?
    private var emojiRotationGestureRecognizer: UIRotationGestureRecognizer?
    
    private var initialImageCenter = CGPoint()
    private var initialEmojiCenter = CGPoint()
    
    @IBAction private func selectImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction private func addEmoji(_ sender: Any) {
        let emojiImage = "🐷".image()
        emojiImageView = UIImageView(image: emojiImage)
        guard let emojiImageView = emojiImageView else {
            return
        }
        
        imageContainerView.addSubview(emojiImageView)
        emojiImageView.center = view.center
        emojiImageView.isUserInteractionEnabled = true
        
        emojiPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        if let emojiPanGestureRecognizer = emojiPanGestureRecognizer {
            emojiImageView.addGestureRecognizer(emojiPanGestureRecognizer)
            emojiPanGestureRecognizer.delegate = self
        }
        
        emojiPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch(_:)))
        if let emojiPinchGestureRecognizer = emojiPinchGestureRecognizer {
            emojiImageView.addGestureRecognizer(emojiPinchGestureRecognizer)
            emojiPinchGestureRecognizer.delegate = self
        }
        
        emojiRotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotate(_:)))
        if let emojiRotationGestureRecognizer = emojiRotationGestureRecognizer {
            emojiImageView.addGestureRecognizer(emojiRotationGestureRecognizer)
            emojiRotationGestureRecognizer.delegate = self
        }
    }
    
    @IBAction private func render(_ sender: Any) {
        performSegue(withIdentifier: "render", sender: self)
    }
    
    @IBAction private func pan(_ gestureRecognizer : UIPanGestureRecognizer) {
        guard let pannedView = gestureRecognizer.view else {return}

        let translation = gestureRecognizer.translation(in: pannedView.superview)
        if gestureRecognizer.state == .began {
            if gestureRecognizer == emojiPanGestureRecognizer {
                initialEmojiCenter = pannedView.center
            } else {
                initialImageCenter = pannedView.center
            }
        }

        let initialCenter = (gestureRecognizer == emojiPanGestureRecognizer) ? initialEmojiCenter : initialImageCenter
        if gestureRecognizer.state != .cancelled {
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            pannedView.center = newCenter
        } else {
            pannedView.center = initialCenter
        }
    }
    
    @IBAction func rotate(_ gestureRecognizer : UIRotationGestureRecognizer) {
        guard let rotatedView = gestureRecognizer.view else { return }
             
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
           rotatedView.transform = rotatedView.transform.rotated(by: gestureRecognizer.rotation)
           gestureRecognizer.rotation = 0
        }
    }
    
    @IBAction func pinch(_ gestureRecognizer : UIPinchGestureRecognizer) {
        guard let scaledView = gestureRecognizer.view else { return }

        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            scaledView.transform = scaledView.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale)
            gestureRecognizer.scale = 1
        }
    }
    
    private func renderToImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(imageContainerView.bounds.size, true, 0);
        defer { UIGraphicsEndImageContext() }
        
        imageContainerView.drawHierarchy(in: imageContainerView.bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension EditingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        imageView.image = pickedImage
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditingViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
