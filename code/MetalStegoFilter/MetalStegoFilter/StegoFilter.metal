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

half quantize(half val, half quantum, bool cover);
half quantize(half val, half quantum, bool cover) {
    half remainder = int(val) % int (quantum);
    half mod = cover && remainder > 0 ? quantum : 0;
    return val - remainder + mod;
}


kernel void stego_embded_image( texture2d<half, access::sample> source_texture [[texture(0)]],
                                texture2d<half, access::write> dest_texture [[texture(1)]],
                                sampler sampler_2d [[ sampler(0) ]],
                                constant int &message_byte [[buffer(0)]],
                                constant int &dither [[buffer(1)]],
                                uint2 gid [[thread_position_in_grid]])

{
    const float delta = 40;
    half4 colorAtPixel = source_texture.read(gid);
    float ditheredDelta = delta ;//- dither ;//quantum
    
    float quantum = ditheredDelta;
    bool cover = message_byte == 1  ? true : false;
    
    half r = quantize(colorAtPixel.r, quantum, cover);
    half b = quantize(colorAtPixel.b, quantum, cover) ;//quantize(colorAtPixel.b, quantum, cover);
    half g = quantize(colorAtPixel.g, quantum, cover) ;//quantize(colorAtPixel.g, quantum, cover);
    half a = colorAtPixel.a;
    half4 newColour = half4(r, g, b, a);
    return dest_texture.write(newColour, gid);
}


kernel void stego_decipher_image(texture2d<half, access::sample> source_texture [[texture(0)]],
                                 constant int &dither [[buffer(0)]],
                                 uint2 gid [[thread_position_in_grid]])

{
    //const half4 colorAtPixel = source_texture.read(gid);
    //const int ditheredDelta = delta + dither
    //float val = colorAtPixel.red
    //float remainder = colorAtPixel.red % ditheredDelta;
    
    
}





