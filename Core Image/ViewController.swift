//
//  ViewController.swift
//  Core Image
//
//  Created by Sgmedical on 2016/11/29.
//  Copyright © 2016年 Sgmedical. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard let image = imageView?.image, let cgimg = image.cgImage else {
            print("image view doesn't have an image")
            return
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(0.5, forKey: kCIInputIntensityKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as?  CIImage{
            let filteredImage = UIImage(ciImage: output)
            imageView?.image = filteredImage
        } else {
            print("Image filtering failed")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

