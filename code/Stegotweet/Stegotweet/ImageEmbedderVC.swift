//
//  ImageEmbedderVC.swift
//  Stegotweet
//
//  Created by Terry McCartan on 04/02/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//

import Foundation
import UIKit


class ImageEmbedderVC :  UIViewController {
    
    var stegoFilter = CIStegoFilter()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var outputImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let fileURL = NSBundle.mainBundle().URLForResource("image", withExtension: "jpgf");
        let beginImage = CIImage(contentsOfURL: NSURL.fileURLWithPath("/web/ASE-Thesis/code/Stegotweet/Stegotweet/image.jpg"));
        let embeddedimage = stegoFilter.embedImage(beginImage!, secretMessage: "Test Message");
        let newImage = UIImage(CIImage: embeddedimage);
        self.imageView.image = UIImage(CIImage: beginImage!);
        self.outputImg.image = newImage;
    }
}