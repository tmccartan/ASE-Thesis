//
//  ViewController.swift
//  CoreImageStegoFilter
//
//  Created by Terry McCartan on 02/04/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var secretMessage: String = "This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message, "
    
    let string_500 = "oweOA0OQg81Cnjgg9nGeP2qA8gZswCzinTUeWXnnyMGiwcD3p6VMRQXSTiDGHjSwIZTM40RiNM1MF56PywhgIb7x7EkDPYUEpW1rv2WzVyENDcy1YUK5xo2GZtDgimEErIh5TtkUbo3mHA2ctm08vzg5esqstL2NK2pB30stJ8XoLRGQ97CHhVPDfaPzuAKTvFG8ySvU3cjIwkZvlEIlRhVchKezMe5rxpbFitlDcEr4f7qQDMhOqrq9iAe5BBgJ6oWg1eucPaFDxel2llWVk9m5Joo1WiGwbquBSRsfXlPz5gx4RjYHxAKQTeHZaOORLx4avvWXZvvYDTKClXTcWgUX5MtBbZ7IY94PHAvgTk6jBAt6XsFWAzi9yUTvxangqmoRKvijuiA8Y9AOSs88ax4VSNXAHzjZiP7MMk8kghbCOVOGgApURsf8mKHibCEEgrPwL7GZrO67Dg9v2uaPHXiJQzx68yu4rMTrkMyFGxQtIDDrhzR5"
    let string_250 = "8j1WsYsXSxfI9BYsu8F6EEUL4ouxyxLFcWuk7lK5czsy6OeJWQ9lQqrqzh7ZUPEQyYQqmzka5y7WcmA2Yog9pjgtSwX9mm1MatiKsyJcGnCBCwmRYs1fSRtU4iotXoMAD7UzRuaIKI3hrzTwRVtfRnAlzwCgaK7TskjiOJrpUHjfiPUBhzIKsLMX5peI0xXvbCGzGj58hSXHferVIUGkBC4mSKeBL6fja82HvRhlRDyU09VFiNUkAR39PX"
    let string_100 = "pOfb33BE2OD0Cf7UgSxMNvysADyLi6N0NgwmLyeB2gIWsr1HuVC87o200VFEOvPMvuIhEhyubBe65z49fKZS9lpQix32xJQ1GeHx"
    
    
    let imageSmall = UIImage(named: "jakeTwit")
    let imageMed = UIImage(named: "jakeMedium")
    let imageLarge = UIImage(named: "jakeLarge")
    let delta = 15
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        let image = imageSmall!
        secretMessage = string_500
        let rgba = RGBA(image: image)!
        
        let start = NSDate();
        let height = Int(image.size.height)
        let width  = Int(image.size.width)
        
        let maxNumber = 1
        let minNumber = 0
        let delta = 15
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
                
                let index = y * width + x
           
                let dither = rand() % (maxNumber + 1 - minNumber) + minNumber
                let ditheredRange = Int(delta) - Int(dither)
               
                var pixel = rgba.pixels[index]
                
                if bit == 1 {
                    //if bit is 1 move the pixel toward the center of the nearest postive interval
                    pixel.red = UInt8(quantize(Int(pixel.red), quantum: ditheredRange, cover: true))
                    pixel.green = UInt8(quantize(Int(pixel.green), quantum: ditheredRange, cover: true))
                    pixel.blue = UInt8(quantize(Int(pixel.blue), quantum: ditheredRange, cover: true))

                }
                else{
                    //if bit is 0 move it towards the center of the nearest negative interval
                    pixel.red = UInt8(quantize(Int(pixel.red), quantum: ditheredRange, cover: false))
                    pixel.green = UInt8(quantize(Int(pixel.green), quantum: ditheredRange, cover: false))
                    pixel.blue = UInt8(quantize(Int(pixel.blue), quantum: ditheredRange, cover: false))

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
                        print("Out of possible emdedding space")
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
            pixel.red = pixel.red >= 254 ? 254 : pixel.red + delta
            pixel.green = pixel.green >= 254 ? 254 : pixel.green + delta
            pixel.blue = pixel.blue >= 254 ? 254 : pixel.blue + delta
        }
        else {
            //negative quantizer
            pixel.red = pixel.red == 0 ? 0 : pixel.red - delta
            pixel.green = pixel.green == 0 ? 0 : pixel.green - delta
            pixel.blue = pixel.blue == 0 ? 0 : pixel.blue - delta
        }
        rgba.pixels[index] = pixel
    }
    
    func quantize(val:Int, quantum: Int, cover: Bool) -> Int {
        let remainder = val % quantum;
        let sign = val >= 0 ? 1 : -1;
        
        let mod = cover && remainder > 0 ? quantum : 0;
        return val - remainder + sign * mod;
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
        print(totalBuffer.count)
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
