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
        imageView.image = embedImage(1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
        let context = CIContext(options: nil)
        
        return context.createCGImage(inputImage, fromRect: inputImage.extent)
        
    }
    
    func embedImage(seed :Int) -> UIImage{
        
        let image = UIImage(named: "jakeTwit")!
        
        let rgba = RGBA(image: image)!
        
        let start = NSDate();
        let height = Int(image.size.height)
        let width  = Int(image.size.width)
        
        let maxNumber = 1
        let minNumber = 0
        let delta:UInt8 = 15
        let smallDelta:UInt8 = 1
        var x = 0;
        var y = 0;
        
        srand(UInt32(seed));
        // need to embed the identifer that will speed up image checking
        // the length of text to extract
        // the message itself
        
        let buf = createSecretMessageBytes(width * height);
        
        // need to embed byte
        for byte in buf {
            let strBits = String(UInt(byte), radix: 2);
            let bits = strBits.characters.map { Int(String($0)) }
            for bit in bits {
                // 255 -dither
                // break into ranges of - for 0 bit  and + for 1
                // if bit is 0 move it towards the center of the nearest negative interval
                // if bit is 1 move the pixel toward the center of the nearest postive interval 
                
                let index = y * width + x
           
                let dither = rand() % (maxNumber + 1 - minNumber) + minNumber
                if bit == 1 {
                     changePixelValue(rgba, index: index, sign: bit!, delta: 1);
                }
                else{
                     changePixelValue(rgba, index: index, sign: bit!, delta: 2);
                }
                // if 1 -> r - (r % smallDelta) + smallDelta / 2
                // if 0 -> r
                
                // break offset range into positve and negative ranges by using delta
                // move it forward or back by delta /2 depending on bit
                
                if( (x + 1) != width) {
                    x += 1
                }
                else {
                    x = 0;
                    if(y + 1 == height){
                        //Out of space throw exception
                        break;
                    }
                    y += 1
                }

            }
        }
        let finalImage =  rgba.toUIImage()!
        let end = NSDate();
        let timeInterval: Double = end.timeIntervalSinceDate(start);
        print("Time to embed : \(timeInterval) seconds");
        return finalImage;
    }
    func changePixelValue(rgba: RGBA, index: Int, sign: Int, delta:UInt8) {
        var pixel = rgba.pixels[index]
        
        if(sign == 0){
            //postive quantizer
            pixel.red = pixel.red == 255 ? 255 : pixel.red + delta
            pixel.green = pixel.green == 255 ? 255 : pixel.red + delta
            pixel.blue = pixel.blue == 255 ? 255 : pixel.red + delta
        }
        else {
            //negative quantizer
            pixel.red = pixel.red == 0 ? 0 : pixel.red - delta
            pixel.green = pixel.green == 0 ? 0 : pixel.red - delta
            pixel.blue = pixel.blue == 0 ? 0 : pixel.red - delta
        }
        rgba.pixels[index] = pixel
    }
    func createSecretMessageBytes (maxSize : Int) -> [UInt8] {
        let capactyByte1 = UInt16(secretMessage.characters.count)
        let b1 = UInt8(capactyByte1 >> 8)
        let b2 = UInt8(capactyByte1 & 0x00ff)
        
        let identifierString = "StegoTweet"
        
        var totalBuffer = [UInt8](count: maxSize, repeatedValue: 0)
        var buf = [UInt8](identifierString.utf8);
        buf.append(b1)
        buf.append(b2)
        buf.appendContentsOf(secretMessage.utf8)
        totalBuffer[0..<buf.count] = buf[0..<buf.count]
        return totalBuffer
    }

    func decipherImage(){
        // read all pixels into array
        // foreach pixel
        // the value is either 1 or zero for the bit
        //
        
        
    }

    func pad(string : String, toSize: Int) -> String {
        var padded = string
        for _ in 0..<toSize - string.characters.count {
            padded = "0" + padded
        }
        return padded
    }
    func noOp (){
        
        
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
