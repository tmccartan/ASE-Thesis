//
//  CIStegoFilter.swift
//  Stegotweet
//
//  Created by Terry McCartan on 22/02/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//

import Foundation
import CoreImage


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
        //let location = NSBundle.mainBundle().pathForResource("", ofType: nil)
        let kernelString = try? NSString(contentsOfFile: "/web/ASE-Thesis/code/Stegotweet/Stegotweet/CIStegoFilter.cikernel", encoding: NSUTF8StringEncoding)
        return CIKernel(string: kernelString as! String)!
    }
    
    private func roiFunction(index : Int32, rect:CGRect) -> CGRect {
        
        print("roi called")
        return rect;
    }
    
    func embedImage(image :CIImage, secretMessage: String) -> CIImage {
        
        // change message into byte array
        // break image into sections
        // foreach bit in the array
        // encode bit into image section
        message = secretMessage
        inputImage = image;
        let buf = [UInt8](message!.utf8)
        var xcoord :Int = 0;
        var ycoord : Int = 0;
        //let height :Int = 20
        //let width: Int = 20;
        for byte in buf {
            let strBits = String(UInt(byte), radix: 2);
            let bits = strBits.characters.map { String($0) }

            for bit in bits {
                var args = [inputImage as! AnyObject];
                args.append(Int(bit) as! AnyObject);
                //let dod = CGRect.init(x: xcoord, y: ycoord, width: width, height: height)
                let dod = image.extent
                inputImage = kernel!.applyWithExtent(dod, roiCallback: roiFunction, arguments: args)
                xcoord++;
                ycoord++;
            }
        }
        return inputImage!;
    }
    
    func dechiperImage( image:CIImage) -> String {
        return "To Be Implemented"
    }
}
