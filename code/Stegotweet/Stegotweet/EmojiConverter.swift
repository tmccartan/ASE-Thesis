//
//  EmojiConverter.swift
//  Stegotweet
//
//  Created by Terry McCartan on 09/04/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//

import Foundation



var someDict:[Int: String] = [1:"😃",
                             2: "🙂",
                             3:"😬",
                             4: "😂",
                             5: "😜",
                             6: "😝",
                             7: "😎",
                             8: "😁",
                             9: "😊",
                             0: "😆"];


func convertToEmojj(pk :Int)-> String {
    
    var emojjis = "";
    for int in pk.array{
        emojjis += someDict[int]!;
    }
    return emojjis;
}

func convertToInt(emojjis: String)-> Int{
    
    let ints = emojjis.characters.map { findKeyForValue(String($0), dictionary: someDict)}
    let stringNum = ints.flatMap { String($0!) }.joinWithSeparator("")
    return Int(stringNum)!
}

extension Int {
    var array: [Int] {
        return description.characters.map{Int(String($0)) ?? 0}
    }
}
func findKeyForValue(value: String, dictionary: [Int: String]) -> Int?
{
    for (key, array) in dictionary
    {
        if (array == value)
        {
            return key
        }
    }
    
    return nil
}