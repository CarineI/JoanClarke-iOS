//
//  TokenFactory.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 2/2/17.
//  Copyright © 2017 Carine Iskander. All rights reserved.
//

import Foundation

class TokenFactory
{
    static func CreateToken(pattern : String, startIndex :  inout String.CharacterView.Index) throws -> Token
    {
        VerifyElseCrash(startIndex <= pattern.characters.endIndex)
        
       // let char = pattern.substring(with: startIndex..<pattern.index(after: startIndex))
        let char = pattern.characters[startIndex]
        
        if (DotToken.IsToken(ch: String(char)))
        {
            startIndex = pattern.index(after: startIndex)
            return DotToken(tokenChar: char)
        }
        // TODO: CryptoToken
        if ((char >= "a" && char <= "z") || (char >= "A" && char <= "Z"))
        {
            startIndex = pattern.index(after: startIndex)
            return LetterToken(letter: char)
        }
        if (char == "*")
        {
            startIndex = pattern.index(after: startIndex)
            return StarToken()
        }
        
        // Multi-character tokens
        if (char == "<")
        {
            let remainder = pattern.substring(from: pattern.index(after: startIndex))
            let iCloseBracket = remainder.characters.index(of: ">")
            if (iCloseBracket == nil)
            {
                throw PatternError.mismatchedBraces
            }
            let anagramPattern = remainder.substring(to: iCloseBracket!)
            startIndex = pattern.index(startIndex, offsetBy: anagramPattern.characters.count + 2)
            return try AnagramToken(pattern: anagramPattern)
        }
        
        throw PatternError.unrecognizedToken(token: String(char))
    }

    static func CreateEndToken(pattern : String) -> Token
    {
        return EndToken()
    }
}
