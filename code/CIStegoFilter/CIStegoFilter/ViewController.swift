//
//  ViewController.swift
//  CIStegoFilter
//
//  Created by Terry McCartan on 02/04/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let secretmessage: String = "This is a secret message"


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func embbedImage(inputImage :CIImage) {
        
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

