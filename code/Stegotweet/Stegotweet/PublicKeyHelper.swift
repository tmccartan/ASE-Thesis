//
//  PublicKeyHelper.swift
//  Stegotweet
//
//  Created by Terry McCartan on 09/04/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//

// Uses heimdall from here https://github.com/henrinormak/Heimdall


import Foundation
import Heimdall

class PublicKeyHelper {
    
    let localHeimdall = Heimdall(tagPrefix: "com.example");
    
    func generatePublicKey () -> String{
        
        if let heimdall = localHeimdall, publicKeyData = heimdall.publicKeyDataX509() {
            
            var publicKeyString = publicKeyData.base64EncodedStringWithOptions([])
            
            // If you want to make this string URL safe,
            // you have to remember to do the reverse on the other side later
            publicKeyString = publicKeyString.stringByReplacingOccurrencesOfString("/", withString: "_")
            publicKeyString = publicKeyString.stringByReplacingOccurrencesOfString("+", withString: "-")
            
            return publicKeyString; // Something along the lines of "MIGfMA0GCSqGSIb3DQEBAQUAA..."
            
            // Data transmission of public key to the other party
        }else {
            return "Not able to encrypt"
        }
        
    }
    
    func encrypt(keyData :NSData) -> String {
        
        if let partnerHeimdall = Heimdall(publicTag: "com.example.partner", publicKeyData: keyData) {
            // Transmit some message to the partner
            let message = "This is a secret message to my partner"
            let encryptedMessage = partnerHeimdall.encrypt(message)
            return encryptedMessage!;
            // Transmit the encryptedMessage back to the origin of the public key
        }
        else {
            return "";
        }
    }
    
    func decrypt(encryptedMessage: String) -> String {
        if let heimdall = localHeimdall {
            if let decryptedMessage = heimdall.decrypt(encryptedMessage) {
                return decryptedMessage
            } else {
                return "Unable to decrypt"
            }
        }
        else {
            return "not able to get local heimdall";
        }
    }
}
