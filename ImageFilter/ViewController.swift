//
//  ViewController.swift
//  ImageFilter
//
//  Created by Jackson Isaac on 05/11/16.
//  Copyright © 2016 Jackson Isaac. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var image: UIImage?
    var filteredImage: UIImage?
    var imageProcessor: ImageProcessor?
    var filterName: String?
    
    @IBOutlet var compareButton: UIButton!
    
    @IBOutlet var editButton: UIButton!
    
    @IBOutlet var originalOverlay: UIView!
    
    @IBOutlet var filterSlider: UISlider!
    
    // Interface Builer Outlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var filteredImageView: UIImageView!
    
    @IBOutlet var filterMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet var sliderView: UIView!
    
    @IBOutlet var filterCollection: UICollectionView!
    
    @IBOutlet var filterButton: UIButton!
    
    var filters:[UIImage] = [#imageLiteral(resourceName: "negativeFilter"), #imageLiteral(resourceName: "redFilter"), #imageLiteral(resourceName: "blueFilter"),
                             #imageLiteral(resourceName: "greenFilter"), #imageLiteral(resourceName: "alphaFilter")]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set AutoresizingIntoContraints false to comply with the constraints set
        // using code.
        filterMenu.translatesAutoresizingMaskIntoConstraints = false
        originalOverlay.translatesAutoresizingMaskIntoConstraints = false
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        
        image = imageView.image
        compareButton.isEnabled = false
        editButton.isEnabled = false
        
        filterCollection.dataSource = self
        filterCollection.delegate = self
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
    
    @IBAction func onNewPhoto(_ sender: Any) {
        if self.sliderView.isDescendant(of: self.view) {
            hideSlider()
            editButton.isSelected = false
        }
        if self.filterMenu.isDescendant(of: self.view) {
            hideFilterMenu()
            filterButton.isSelected = false
        }
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
    
    @IBAction func onFilter(_ sender: UIButton) {
        if(sender.isSelected) {
            hideFilterMenu()
            sender.isSelected = false
        } else {
            if self.sliderView.isDescendant(of: self.view) {
                hideSlider()
                editButton.isSelected = false
            }
            showFilterMenu()
            sender.isSelected = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            filterName = "negative"
        case 1:
            filterName = "redFilter"
        case 2:
            filterName = "blueFilter"
        case 3:
            filterName = "greenFilter"
        case 4:
            filterName = "alphaFilter"
        default:
            print("Nothing to Do!")
        }
        if filterName != nil {
            applyFilter(filterName: filterName!)
            enableCompareEditButton()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterIdentifier", for: indexPath) as! FilterPhotoCell
        cell.filterImage.image = filters[indexPath.row]
        return cell
    }
    
    @IBAction func onEdit(_ sender: UIButton) {
        if(sender.isSelected) {
            hideSlider()
            sender.isSelected = false
        } else {
            if self.filterMenu.isDescendant(of: self.view) {
                filterButton.isSelected = false
                hideFilterMenu()
            }
            showSlider()
            sender.isSelected = true
        }
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
    
    @IBAction func onShare(_ sender: Any) {
        let activityController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    // Begin defining user functions.
    func applyFilter(filterName: String, val: Int = 255) {
        imageProcessor = ImageProcessor(imageRGBA: RGBAImage(image: self.image!)!)
        filteredImage = imageProcessor?.applyFilter(filterName, val: val).toUIImage()
        showFilteredImage(filteredImage: filteredImage!)
    }
    
    func showFilteredImage(filteredImage: UIImage) {
        imageView.alpha = 1
        filteredImageView.alpha = 0
        
        filteredImageView.image = filteredImage
        
        UIView.animate(withDuration: 0.4) {
            self.filteredImageView.alpha = 1.0
            self.imageView.alpha = 0
        }
    }
    
    // Functions handling image views and button actions.
    func showOriginalImage() {
        imageView.alpha = 0
        filteredImageView.alpha = 1
        
        filteredImageView.image = filteredImage
        
        UIView.animate(withDuration: 0.4) {
            self.filteredImageView.alpha = 0
            self.imageView.alpha = 1
        }
    }
    
    func enableCompareEditButton() {
        if compareButton.isEnabled == false {
            compareButton.isEnabled = true
        }
        if editButton.isEnabled == false {
            editButton.isEnabled = true
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

    
    // Functions handling image picker using Camera or Photo Album.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            // If image size is greater than 200*200 pixels then scale down the image for fast processing.
            if image.size.height * image.size.width >= 40000 {
                let scaledImage = image.resizeWith(percentage: 0.35)
                imageView.image = scaledImage
                self.image = scaledImage
            } else {
                imageView.image = image
                self.image = image
            }
            if filteredImageView.alpha == 1 {
                showOriginalImage()
                filteredImage = nil
                filterName = nil
                compareButton.isEnabled = false
                editButton.isEnabled = false
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func filterIntensityChanged(_ sender: UISlider) {
        applyFilter(filterName: filterName!, val: Int(filterSlider.value))
    }
    
    
    // Functions handling secondary UIViews.
    func showSlider() {
        
        view.addSubview(sliderView)
        
        let bottomConstraint = sliderView.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = sliderView.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = sliderView.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = sliderView.heightAnchor.constraint(equalToConstant: 44)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.sliderView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.sliderView.alpha = 1.0
        }
    }
    
    func hideSlider() {
        UIView.animate(withDuration: 0.4, animations: {
            self.sliderView.alpha = 0
        }, completion: { completed in
            if completed == true {
                self.sliderView.removeFromSuperview()
            }
        })
    }
    
    func showFilterMenu() {
        view.addSubview(filterMenu)
        
        let bottomConstraint = filterMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = filterMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = filterMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = filterMenu.heightAnchor.constraint(equalToConstant: 75)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.filterMenu.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.filterMenu.alpha = 1.0
        }
        
    }
    
    func hideFilterMenu() {
        UIView.animate(withDuration: 0.4, animations: {
            self.filterMenu.alpha = 0
        }, completion: { completed in
            if completed == true {
                self.filterMenu.removeFromSuperview()
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
        
        showOriginalImage()
    }
    
    func hideOverlayOriginalImage() {
        self.originalOverlay.removeFromSuperview()
        if (filteredImage != nil) {
            showFilteredImage(filteredImage: filteredImage!)
        }
    }

}

// From StackOverflow: http://stackoverflow.com/a/29138120
extension UIImage {
    func resizeWith(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWith(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}

