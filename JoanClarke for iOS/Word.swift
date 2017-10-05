//
//  Word.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 9/27/17.
//  Copyright © 2017 Carine Iskander. All rights reserved.
//

import Foundation

class Word
{
    /// The actual word, with casing
    var _original : String;
    /// All lower case for searching
    var _allCaps : String;
    /// Mask of which letters are present in the word
    var _letterMask : UInt32 = 0
    
    init(str: String)
    {
        _original = str;
        _allCaps = str;
        _letterMask = Word.CalcLetterMask(str: str)
    }
    
    static func CalcLetterMask(str: String) -> UInt32
    {
        var mask : UInt32 = 0
        for c in str.characters
        {
            let cAsString = String(c)
            let ascii = cAsString.unicodeScalars.first?.value
            if (ascii! >= 65 && ascii! <= 90)
            {
                mask |= (0x1 << (ascii! - 65))
            }
        }
        return mask;
    }
    
    func ContainsAllLetters(letterMask: UInt32) -> Bool
    {
        return _letterMask & letterMask == letterMask
    }
    
    func ContainsSomeLetters(letterMask: UInt32) -> Bool
    {
        return _letterMask & letterMask != 0
    }
    
    var Normalized : String { get {return _allCaps}}
    var Original : String { get {return _original}}
    var LetterMask : UInt32 { get { return _letterMask}}

}
