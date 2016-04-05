//
//  ViewController.swift
//  CIStegoFilter
//
//  Created by Terry McCartan on 02/04/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let secretMessage: String = "This is a secret message"


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func embbedImage(inputImage :CIImage) {
        let buf = [UInt8](secretMessage.utf8);
        
        // calcutate intensity i.3 R x G x B
        // split by delta + dither?
        // for each bit
            // find if current bit is in delta + or -  using modulo
            // if + ceiling it
        
        
    }
    
    func decipherImage(inputImage: CIImage, dither: Int){
        
    }
    private func createKernel() -> CIKernel {
        
        var kernel : CIKernel? = nil;
        do {
            let kernelString = try String(contentsOfURL: NSBundle.mainBundle().URLForResource("stego", withExtension: "cikernel")!)
            kernel = (CIKernel(string: kernelString))!
            
        } catch {
            print(error)
        }
        return kernel!
    }



}

