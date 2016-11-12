//
//  ViewController.swift
//  ImageFilter
//
//  Created by Jackson Isaac on 05/11/16.
//  Copyright © 2016 Jackson Isaac. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var image: UIImage?
    var filteredImage: UIImage?
    var imageProcessor: ImageProcessor?
    
    @IBOutlet var compareButton: UIButton!
    
    @IBOutlet var originalOverlay: UIView!
    
    // Interface Builer Outlet
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    
    @IBOutlet var filterButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        secondaryMenu.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        originalOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        image = imageView.image
//        filteredImage = image
        compareButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        showOverlayOriginalImage()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideOverlayOriginalImage()
    }
    
    @IBAction func onCompare(_ sender: UIButton) {
        if(sender.isSelected) {
            hideOverlayOriginalImage()
            sender.isSelected = false
        } else {
            showOverlayOriginalImage()
            sender.isSelected = true
        }
    }
    
    @IBAction func onNegativeFilter(_ sender: UIButton) {
        enableCompareButton()
        if(sender.isSelected) {
            imageView.image = image
            sender.isSelected = false
        } else {
            if (filteredImage != nil) {
                imageProcessor = ImageProcessor(imageRGBA: RGBAImage(image: self.filteredImage!)!)
            } else {
                imageProcessor = ImageProcessor(imageRGBA: RGBAImage(image: self.image!)!)
            }
            filteredImage = imageProcessor?.applyFilter("negative").toUIImage()
            imageView.image = filteredImage

            sender.isSelected = true
        }
    }
    
    @IBAction func onRedFilter(_ sender: UIButton) {
        enableCompareButton()
        if(sender.isSelected) {
            imageView.image = image
            sender.isSelected = false
        } else {
            if (filteredImage != nil) {
                imageProcessor = ImageProcessor(imageRGBA: RGBAImage(image: self.filteredImage!)!)
            } else {
                imageProcessor = ImageProcessor(imageRGBA: RGBAImage(image: self.image!)!)
            }
            filteredImage = imageProcessor?.applyFilter("redFilter").toUIImage()
            imageView.image = filteredImage
            
            sender.isSelected = true
        }
    }
    
    @IBAction func onBlueFilter(_ sender: UIButton) {
        enableCompareButton()
        if(sender.isSelected) {
            imageView.image = image
            sender.isSelected = false
        } else {
            if (filteredImage != nil) {
                imageProcessor = ImageProcessor(imageRGBA: RGBAImage(image: self.filteredImage!)!)
            } else {
                imageProcessor = ImageProcessor(imageRGBA: RGBAImage(image: self.image!)!)
            }
            filteredImage = imageProcessor?.applyFilter("blueFilter").toUIImage()
            imageView.image = filteredImage
            
            sender.isSelected = true
        }
    }
    
    @IBAction func onGreenFilter(_ sender: UIButton) {
        enableCompareButton()
        if(sender.isSelected) {
            imageView.image = image
            sender.isSelected = false
        } else {
            if (filteredImage != nil) {
                imageProcessor = ImageProcessor(imageRGBA: RGBAImage(image: self.filteredImage!)!)
            } else {
                imageProcessor = ImageProcessor(imageRGBA: RGBAImage(image: self.image!)!)
            }
            filteredImage = imageProcessor?.applyFilter("greenFilter").toUIImage()
            imageView.image = filteredImage
            
            sender.isSelected = true
        }
    }

    @IBAction func onAlphaFilter(_ sender: UIButton) {
        enableCompareButton()
        if(sender.isSelected) {
            imageView.image = image
            sender.isSelected = false
        } else {
            if (filteredImage != nil) {
                imageProcessor = ImageProcessor(imageRGBA: RGBAImage(image: self.filteredImage!)!)
            } else {
                imageProcessor = ImageProcessor(imageRGBA: RGBAImage(image: self.image!)!)
            }
            filteredImage = imageProcessor?.applyFilter("alphaFilter").toUIImage()
            imageView.image = filteredImage
            
            sender.isSelected = true
        }
    }
    
    @IBAction func onShare(_ sender: Any) {
        let activityController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        
    }
    
    @IBAction func onNewPhoto(_ sender: Any) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default, handler: { action
            in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func enableCompareButton() {
        if compareButton.isEnabled == false {
            compareButton.isEnabled = true
        }
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .photoLibrary
        
        present(cameraPicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
            self.image = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onFilter(_ sender: UIButton) {
        if(sender.isSelected) {
            hideSecondaryMenu()
            sender.isSelected = false
        } else {
            showSecondaryMenu()
            sender.isSelected = true
        }
    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraint(equalToConstant: 44)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0

        UIView.animate(withDuration: 0.4) {
            self.secondaryMenu.alpha = 1.0
        }
        
    }
    
    func hideSecondaryMenu() {
        UIView.animate(withDuration: 0.4, animations: {
            self.secondaryMenu.alpha = 0
        }, completion: { completed in
            if completed == true {
                self.secondaryMenu.removeFromSuperview()
            }
        })
    }
    
    func showOverlayOriginalImage() {
        view.addSubview(originalOverlay)
        
        let topConstraint = originalOverlay.topAnchor.constraint(equalTo: view.topAnchor)
        let leftConstraint = originalOverlay.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = originalOverlay.rightAnchor.constraint(equalTo: view.rightAnchor)

        let heightConstraint = originalOverlay.heightAnchor.constraint(equalToConstant: 44)

        NSLayoutConstraint.activate([topConstraint, leftConstraint, rightConstraint, heightConstraint])

        view.layoutIfNeeded()
        
        imageView.image = image
    }
    
    func hideOverlayOriginalImage() {
        self.originalOverlay.removeFromSuperview()
        if (filteredImage != nil) {
            imageView.image = filteredImage
        }
    }

}

