//
//  ViewController.swift
//  MetalStegoFilter
//
//  Created by Terry McCartan on 09/04/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//

import UIKit
import Metal

class ViewController: UIViewController {
    
    @IBOutlet weak var imageview: UIImageView!

    let secretMessage: String = "This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message, "
    let image = CIImage(image: UIImage(named: "jakeTwit")!)
    let seed = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let device: MTLDevice = MTLCreateSystemDefaultDevice()!
        // Create a default library
        let defaultLibrary: MTLLibrary = device.newDefaultLibrary()!
        
        // Create a command queue
        let commandQueue: MTLCommandQueue = device.newCommandQueue()
        // reference to the function
        let kernelFunction: MTLFunction = defaultLibrary.newFunctionWithName("stego_embded_image")!
        //source image texture container
        let sourceImageTexture = MetalTexture(resourceName: "jakeTwit", ext: ".jpg", mipmaped: false)
        let destImageTexture = MetalTexture(resourceName: "jakeTwit", ext: ".jpg", mipmaped: false)
        // Define the pipeline state
        let pipelineState: MTLComputePipelineState =
            try! device.newComputePipelineStateWithFunction(kernelFunction)
        
        // Define the command buffer
        let commandBuffer: MTLCommandBuffer = commandQueue.commandBuffer()
        
        //Define the command encoder
        let commandEncoder: MTLComputeCommandEncoder = commandBuffer.computeCommandEncoder()
        commandEncoder.setComputePipelineState(pipelineState)
     
        
        // Create a command queue
        let imageLoadCommandQueue: MTLCommandQueue = device.newCommandQueue()
        //load the source image texture
        
        sourceImageTexture.loadTexture(device: device, commandQ: imageLoadCommandQueue, flip: false)
        destImageTexture.loadTexture(device: device, commandQ: imageLoadCommandQueue, flip: false)
        
        let height = sourceImageTexture.texture.height
        let width = sourceImageTexture.texture.width
        
        let mesageBytes = createSecretMessageBytes(width * height)
        let ditherValues = createDitherValues(10, amount: mesageBytes.count)
        let secretMessageBuffer = device.newBufferWithBytes(
            mesageBytes, length: mesageBytes.count, options:[])
        let ditherBuffer =  device.newBufferWithBytes(
            ditherValues, length: ditherValues.count, options:[])
        
        let sampler = defaultSampler(device)
        commandEncoder.setSamplerState(sampler, atIndex: 0);
        commandEncoder.setTexture(sourceImageTexture.texture, atIndex: 0);
        commandEncoder.setTexture(destImageTexture.texture, atIndex: 1);
        commandEncoder.setBuffer(secretMessageBuffer, offset: 0, atIndex: 0);
        commandEncoder.setBuffer(ditherBuffer, offset: 0, atIndex: 1)
        
        let threadgroupCounts = MTLSizeMake(8, 8, 1);
        let threadgroups = MTLSizeMake(sourceImageTexture.texture.width / threadgroupCounts.width,
                                           sourceImageTexture.texture.height / threadgroupCounts.height,
                                           1);
        commandEncoder.dispatchThreadgroups(threadgroups, threadsPerThreadgroup: threadgroupCounts)
        

        commandEncoder.endEncoding()
        
        commandBuffer.commit();
        
        imageview.image = destImageTexture.image()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func embedImage(){
        

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
        return totalBuffer
    }
    func createDitherValues (seed:Int, amount:Int) -> [Int] {
        
        var dithers: [Int] = [];
        // this should be more random but for scenario is fine
        let maxNumber = 10;
        let minNumber = 1;
        
        
        srand(UInt32(seed));
        for _ in 0.stride(to: amount, by: 1){
            let dither = rand() % (maxNumber + 1 - minNumber) + minNumber
            dithers.append(Int(dither))
        }
        return dithers
    }
    func defaultSampler(device: MTLDevice) -> MTLSamplerState
    {
        let pSamplerDescriptor:MTLSamplerDescriptor? = MTLSamplerDescriptor();
        
        if let sampler = pSamplerDescriptor
        {
            sampler.minFilter             = MTLSamplerMinMagFilter.Nearest
            sampler.magFilter             = MTLSamplerMinMagFilter.Nearest
            sampler.mipFilter             = MTLSamplerMipFilter.Nearest
            sampler.maxAnisotropy         = 1
            sampler.sAddressMode          = MTLSamplerAddressMode.ClampToEdge
            sampler.tAddressMode          = MTLSamplerAddressMode.ClampToEdge
            sampler.rAddressMode          = MTLSamplerAddressMode.ClampToEdge
            sampler.normalizedCoordinates = true
            sampler.lodMinClamp           = 0
            sampler.lodMaxClamp           = FLT_MAX
        }
        else
        {
            print(">> ERROR: Failed creating a sampler descriptor!")
        }
        return device.newSamplerStateWithDescriptor(pSamplerDescriptor!)
    }

}

