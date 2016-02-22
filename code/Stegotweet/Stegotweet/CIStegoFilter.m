//
//  CIStegoFilter.m
//  Stegotweet
//
//  Created by Terry McCartan on 02/02/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//
#import "Foundation/Foundation.h"
#import "CIStegoFilter.h"
@import CoreImage;

static CIKernel *stegoFilterKernel = nil;

@implementation CIStegoFilter

- (id)init
{
    if(stegoFilterKernel == nil)
    {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"CIStegoFilter"
                                                         ofType:@"cikernel"];
        NSError* error = nil;
        NSString* content = [NSString stringWithContentsOfFile:path
                                                      encoding:NSUTF8StringEncoding
                                                         error:&error];
        if(error) { // If error object was instantiated, handle it.
            NSLog(@"ERROR while loading from file: %@", error);
            // …
        }
        NSArray *kernels = [CIKernel kernelsWithString: content];
        stegoFilterKernel = kernels[0];
        
        
    }
    return [super init];
}
@end