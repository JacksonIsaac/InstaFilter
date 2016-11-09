//
//  ImageProcessor.swift
//  ImageFilter
//
//  Created by Jackson Isaac on 05/11/16.
//  Copyright © 2016 Jackson Isaac. All rights reserved.
//

import Foundation

class ImageProcessor {
    var totalRed = 0
    var totalBlue = 0
    var totalGreen = 0
    var pixelCount = 0
    
    var imageRGBA:RGBAImage?
    
    // Constructor
    init?(imageRGBA: RGBAImage) {
        self.imageRGBA = imageRGBA
        pixelCount = imageRGBA.width * imageRGBA.height
        countRGBVal()
    }
    
    // Count and store RGB values of the image.
    func countRGBVal(){
        // 1a. Loop through each pixel of the image
        for y in 0..<self.imageRGBA!.height{
            for x in 0..<self.imageRGBA!.width {
                let index = y*self.imageRGBA!.width + x
                let pixel = self.imageRGBA!.pixels[index]
                self.totalRed += Int(pixel.red)
                self.totalGreen += Int(pixel.green)
                self.totalBlue += Int(pixel.blue)
            }
        }
    }
    
    // Apply filter with custom intensity to the image and return the RGBAImage.
    func applyFilter(_ filter: String, val: Int = 255) -> RGBAImage {
        var newImage = self.imageRGBA!
        // Loop through each pixel of the image
        for y in 0..<newImage.height{
            for x in 0..<newImage.width {
                let index = y*newImage.width + x
                var pixel = newImage.pixels[index]
                
                // Switch-case for different type of filters.
                switch filter {
                // Negative of the image
                case "negative":
                    pixel.red = UInt8(max(0, min(255,UInt8(255-pixel.red))))
                    pixel.green = UInt8(max(0, min(255,UInt8(255-pixel.green))))
                    pixel.blue = UInt8(max(0, min(255,UInt8(255-pixel.blue))))
                    newImage.pixels[index] = pixel
                // Add red color filter to the whole image.
                case "redFilter":
                    pixel.red = UInt8(max(0, min(255,val)))
                    newImage.pixels[index] = pixel
                    break
                // Add green color filter to the whole image.
                case "greenFilter":
                    pixel.green = UInt8(max(0, min(255,val)))
                    newImage.pixels[index] = pixel
                    break
                // Add blue color filter to the whole image.
                case "blueFilter":
                    pixel.blue = UInt8(max(0, min(255,val)))
                    newImage.pixels[index] = pixel
                    break
                // Make the image either transparent (0) or opaque(255)
                case "alphaFilter":
                    pixel.alpha = UInt8(max(0, min(255,val)))
                    newImage.pixels[index] = pixel
                    break
                default:
                    print("Nothing to do!")
                    return newImage
                }
            }
        }
        return newImage
    }
}
