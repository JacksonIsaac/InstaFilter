//
//  ViewController.swift
//  ImageFilter
//
//  Created by Jackson Isaac on 05/11/16.
//  Copyright © 2016 Jackson Isaac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var filteredImage: UIImage?
    
    // Interface Builer Outlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageToggle: UIButton!
    
    @IBAction func onImageToggle(_ sender: UIButton) {
        if imageToggle.isSelected {
            let image = UIImage(named: "sample")!
            imageView.image = image
            imageToggle.isSelected = false
        } else {
            imageView.image = filteredImage
            imageToggle.isSelected = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let image = UIImage(named: "sample")!
        let imageProcessor:ImageProcessor = ImageProcessor(imageRGBA: RGBAImage(image:image)!)!
        
        filteredImage = imageProcessor.applyFilter("negative").toUIImage()
        
        print("Execution finished")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

