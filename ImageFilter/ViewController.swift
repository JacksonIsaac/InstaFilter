//
//  ViewController.swift
//  ImageFilter
//
//  Created by Jackson Isaac on 05/11/16.
//  Copyright © 2016 Jackson Isaac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Interface Builer Outlet
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let image = UIImage(named: "sample")!
        let imageProcessor:ImageProcessor = ImageProcessor(imageRGBA: RGBAImage(image:image)!)!
        
        let filteredImage = imageProcessor.applyFilter("negative").toUIImage()
        
        imageView.image = filteredImage
        
        print("Execution finished")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

