//
//  CIStegoFilter.swift
//  Stegotweet
//
//  Created by Terry McCartan on 22/02/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//

// Moved to individual projects

import Foundation
import CoreImage
import UIKit


class CIStegoFilter : CIFilter {
    
    func embedImage(image :CIImage, secretMessage: String) -> CIImage {
        
        return image;
    }
    
    func dechiperImage(image:CIImage) -> CIImage {
        return  image;
    }
    
}


