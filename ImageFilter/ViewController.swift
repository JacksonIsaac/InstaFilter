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
    
    @IBAction func onImageToggle(sender: UIButton) {
        imageView.image = filteredImage
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

