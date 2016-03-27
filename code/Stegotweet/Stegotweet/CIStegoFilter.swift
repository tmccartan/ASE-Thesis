//
//  CIStegoFilter.swift
//  Stegotweet
//
//  Created by Terry McCartan on 22/02/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

public struct PixelData {
    var a:UInt8 = 255
    var r:UInt8
    var g:UInt8
    var b:UInt8
}

class CIStegoFilter : CIFilter {
    
    var kernel: CIKernel?
    var inputImage: CIImage?
    var message : String?
    
    
    override init() {
        super.init()
        kernel = createKernel()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        kernel = createKernel()
    }
    
    private func createKernel() -> CIKernel {

        var kernel : CIKernel? = nil;
        do {
            let kernelString = try String(contentsOfURL: NSBundle.mainBundle().URLForResource("CIStegoFilter", withExtension: "cikernel")!)
            kernel = (CIKernel(string: kernelString))!
            
        } catch {
            print(error)
        }
        return kernel!
    }
    
    private func roiFunction(index : Int32, rect:CGRect) -> CGRect {
        
        return rect;
    }
    
    private let rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    private let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue);
    
    private func imageFromARGB32Bitmap(pixels:[PixelData], width:Int, height:Int) -> CGImage {
        let bitsPerComponent:Int = 8
        let bitsPerPixel:Int = 32
        
        assert(pixels.count == Int(width * height))
        
        var data = pixels // Copy to mutable []
        let providerRef = CGDataProviderCreateWithCFData(
            NSData(bytes: &data, length: data.count * sizeof(PixelData))
        )
        
        let cgim = CGImageCreate(
            width,
            height,
            bitsPerComponent,
            bitsPerPixel,
            width * Int(sizeof(PixelData)),
            rgbColorSpace,
            bitmapInfo,
            providerRef,
            nil,
            true,
            .RenderingIntentDefault
        )
        return cgim!;
    }
    
    func embedImage(inputImage :CIImage, secretMessage: String) -> CIImage {
        
        let pixelData = generateMessagePixelData(secretMessage);
        let secretImage = imageFromARGB32Bitmap(pixelData, width: 200,height: 200);
        let resultImage = performImageEmbedding(inputImage, secretImage: secretImage);
        return resultImage;
    }
    
    private func generateMessagePixelData(secretMessage: String) -> [PixelData] {
        
        //create byte array for secretMessage
        //create seed for random dither
        //
        let buf = [UInt8](secretMessage.utf8);
        var pixels = [PixelData]()
        let seed: UInt8 = 1;
        for byte in buf {
            pixels.append(PixelData(a: 255, r: byte, g: seed, b: 0))
        }
        
        return pixels;
    }
    private func performImageEmbedding(inputImage :CIImage, secretImage :CGImage) -> CIImage {
        return inputImage;
    }
    func embedImage2(image :CIImage, secretMessage: String) -> CIImage {
        
        //this function will blend the messageImage values with the input image. 
        
        
        // change message into byte array
        // break image into sections
        // foreach bit in the array
        // encode bit into image section
        message = secretMessage
        inputImage = image;
        
        let buf = [UInt8](message!.utf8)
        print(buf.capacity);
        var xcoord : CGFloat = 1;
        var ycoord : CGFloat = 400;
        var args = [image as AnyObject];
        args.append(Int(0) as AnyObject);
        args.append(CIVector(CGPoint: CGPoint(x: xcoord, y: ycoord)));
        
        //let height :CGFloat = 20;
        //let width: CGFloat = 20;
        for byte in buf {
        
                var args = [inputImage as! AnyObject];
                //args.append(Int(byte) as AnyObject);
                args.append(CIVector(x: xcoord, y: ycoord, z: CGFloat(byte)));
                let dod  = image.extent;
                inputImage = kernel!.applyWithExtent(dod, roiCallback: {(n : Int32, rect: CGRect) -> CGRect in return rect; }, arguments: args)!;
                
                if(xcoord >= image.extent.width) {
                    xcoord = 0;
                    ycoord = ycoord + 1;
                }
                else{
                    xcoord = xcoord + 1;
            }
        }
        return inputImage!;
    }
    
    func dechiperImage(image:CIImage) -> String {
        return "To Be Implemented"
    }
    
}


