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
