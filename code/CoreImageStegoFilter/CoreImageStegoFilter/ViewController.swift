//
//  ViewController.swift
//  CoreImageStegoFilter
//
//  Created by Terry McCartan on 02/04/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let secretMessage: String = "This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message, "
    let image = CIImage(image: UIImage(named: "jakeTwit")!)
    let delta = 15
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(CIImage: image!)
        imageView.image = embedImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
        let context = CIContext(options: nil)
        
        return context.createCGImage(inputImage, fromRect: inputImage.extent)
        
    }
    
    func embedImage() -> UIImage{
        
        let image = UIImage(named: "jakeTwit")!
        let rgba = RGBA(image: image)!
        
        
        let height = Int(image.size.height)
        let width  = Int(image.size.width)
        let seed: UInt32 = 1;
        let maxNumber = 10
        let minNumber = 1
        let delta = 15
        var x = 0;
        var y = 0;
        
        srand(seed);
        let buf = [UInt8](secretMessage.utf8);
        for byte in buf {
            // use dither to move byte
            // find whether in + or minus range
            // move to nearest delta if +, away if -
            
            let dither = rand() % (maxNumber + 1 - minNumber) + minNumber
            let dithByte = byte + UInt8(dither)
            let region = dithByte % 15
            
            let index = y * width + x
            var pixel = rgba.pixels[index]
            
            if(region == 1){
                //postive quantizer
                pixel.red += 1
                pixel.green += 1
                pixel.blue += 1
                //pixel.alpha += 1
            }
            else {
                //negative quantizer
                pixel.red -= 1
                pixel.green -= 1
                pixel.blue -= 1
                //pixel.alpha -= 1
            }
            
            
            rgba.pixels[index] = pixel
            
            if( (x + 1) != width) {
                x += 1
            }
            else {
                x = 0;
                y += 1
            }
            
           
        }
        
        return rgba.toUIImage()!
    }
    
    func pad(string : String, toSize: Int) -> String {
        var padded = string
        for _ in 0..<toSize - string.characters.count {
            padded = "0" + padded
        }
        return padded
    }

}

struct Pixel {
    var value: UInt32
    var red: UInt8 {
        get { return UInt8(value & 0xFF) }
        set { value = UInt32(newValue) | (value & 0xFFFFFF00) }
    }
    var green: UInt8 {
        get { return UInt8((value >> 8) & 0xFF) }
        set { value = (UInt32(newValue) << 8) | (value & 0xFFFF00FF) }
    }
    var blue: UInt8 {
        get { return UInt8((value >> 16) & 0xFF) }
        set { value = (UInt32(newValue) << 16) | (value & 0xFF00FFFF) }
    }
    var alpha: UInt8 {
        get { return UInt8((value >> 24) & 0xFF) }
        set { value = (UInt32(newValue) << 24) | (value & 0x00FFFFFF) }
    }
}

struct RGBA {
    var pixels: UnsafeMutableBufferPointer<Pixel>
    var width: Int
    var height: Int
    init?(image: UIImage) {
        guard let cgImage = image.CGImage else { return nil }
        width = Int(image.size.width)
        height = Int(image.size.height)
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let imageData = UnsafeMutablePointer<Pixel>.alloc(width * height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var bitmapInfo: UInt32 = CGBitmapInfo.ByteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.PremultipliedLast.rawValue & CGBitmapInfo.AlphaInfoMask.rawValue
        guard let imageContext = CGBitmapContextCreate(imageData, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo) else { return nil }
        CGContextDrawImage(imageContext, CGRect(origin: CGPointZero, size: image.size), cgImage)
        pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
    }
    
    func toUIImage() -> UIImage? {
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var bitmapInfo: UInt32 = CGBitmapInfo.ByteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.PremultipliedLast.rawValue & CGBitmapInfo.AlphaInfoMask.rawValue
        let imageContext = CGBitmapContextCreateWithData(pixels.baseAddress, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo, nil, nil)
        guard let cgImage = CGBitmapContextCreateImage(imageContext) else {return nil}
        let image = UIImage(CGImage: cgImage)
        return image
    }
}
