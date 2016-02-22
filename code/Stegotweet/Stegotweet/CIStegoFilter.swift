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
        let location = NSString(string:"~/CIStegoFilter.ciKernel").stringByExpandingTildeInPath
        let kernelString = try? NSString(contentsOfFile: location, encoding: NSUTF8StringEncoding)
        return CIKernel(string: kernelString as! String)!
    }
    
    private func roiFunction(index : Int32, rect:CGRect) -> CGRect {
        
        return CGRectInfinite;
    }
    
    func embedImage(image :CIImage, secretMessage: String) -> CIImage {
        
        message = secretMessage
        // change message into byte array
        // break image into sections
        // foreach bit in the array
            // encode bit into image section
    
        
        let args = [image as AnyObject]
        let dod = inputImage!.extent.insetBy(dx: -1, dy: -1)
        return kernel!.applyWithExtent(dod, roiCallback: roiFunction, arguments: args)!
    }
    
    func dechiperImage( image:CIImage) -> String {
        return "To Be Implemented"
    }    
}
