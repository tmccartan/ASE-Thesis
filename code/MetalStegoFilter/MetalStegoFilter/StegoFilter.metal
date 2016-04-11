//
//  StegoFilter.metal
//  MetalStegoFilter
//
//  Created by Terry McCartan on 09/04/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


// Take source image byte
// take input image byte
// take dither
// do normal calcualtion
// prosper
kernel void stego_embded_image( texture2d<half, access::sample> source_texture [[texture(0)]],
                                texture2d<half, access::write> dest_texture [[texture(1)]],
                                sampler sampler_2d [[ sampler(0) ]],
                                constant int &message_byte [[buffer(0)]],
                                constant int &dither [[buffer(1)]],
                                uint2 gid [[thread_position_in_grid]])

{
   // float4 inColor = source_texture.read(gid).rgba;
  //  inColor.r = 0;
  //  dest_texture.write(inColor, gid);
}

kernel void stego_decipher_image(texture2d<half, access::sample> sourceTexture [[texture(0)]],
                                 constant int &dither [[buffer(0)]],
                                 uint id [[thread_position_in_grid]])

{
    
    
}





