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
        
        //Ensure image isn't nil; 
        //convert imageview's image to cgImage        
        guard let image = imageView?.image, let cgimg = image.cgImage else {
            print("image view doesn't have an image")
            return
        }
        
        //Core Image 是作用在 CIImage, 而不是 UIImage. 所以，所有的UIImage 必須都轉成 CIImage
        let coreImage = CIImage(cgImage: cgimg)
        
        //使用 Core Image 內建的過濾器
        let filter = CIFilter(name: "CISepiaTone")
        
        //將圖放到過濾器中
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        //指定過濾強度為 50%
        filter?.setValue(0.5, forKey: kCIInputIntensityKey)
        
        //呼叫 CoreImage 執行照片過濾, 並強制轉為 CIImage 格式
        if let output = filter?.value(forKey: kCIOutputImageKey) as?  CIImage{
            //將 CIImage 轉為 UIImage, 準備做輸出使用
            let filteredImage = UIImage(ciImage: output)
            //將 ImageView 的圖片, 改為過濾過的圖片
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

