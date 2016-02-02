//
//  CIStegoFilter.h
//  Stegotweet
//
//  Created by Terry McCartan on 02/02/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//
@import CoreImage;

@interface CIStegoFilter: CIFilter
{
    CIImage   *inputImage;
    NSString  *inputMessage;
    NSNumber  *inputDither;
}
@end
