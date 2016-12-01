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
        
        /* 為效能問題, 將影像處理透過 CIContext 由CPU 轉到 GPU 處理 -- Step A  */
        // 建立新的 OpenGL ES context, 它是一個高速的圖形API, 由 GPU 直接產生
        // 此例使用的是 OpenGL ES V2 的版本. 大部份 iOS 設備支援此版本. 
        // 最新出到 ES V3. 如果設備有支援, 改為 openGLES3 即可
        let openGLContext = EAGLContext(api: .openGLES2)
        // 因為我們不能直接使用 OpenGL ES context 做影像過濾, 所以在這將它轉為 CIContext
        let context = CIContext(eaglContext: openGLContext!)
        
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
            
        /* CPU 的處理程序
            //將 CIImage 轉為 UIImage, 準備做輸出使用
            let filteredImage = UIImage(ciImage: output)
            //將 ImageView 的圖片, 改為過濾過的圖片
            imageView?.image = filteredImage
        */
        
        /*  呼叫 GPU 執行影像處理 Step B  */
            // V1: let cgimgresult = context.createCGImage(output, fromRect: output.extent)
            // V2:  
            // 在此我們使用的是 CGImage 的影像, 而不是 CIImage. V1 的 fromRect 是指定影像大小, 但V2 不支援
            // extent 代表的是 "影像大小(image size)"
            let cgimgresult = context.createCGImage(output, from: output.extent)
            let result = UIImage(cgImage: cgimgresult!)
            imageView?.image = result
        } else {
            print("Image filtering failed")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

