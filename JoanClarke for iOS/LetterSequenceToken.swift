//
//  LetterSequenceToken.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 11/22/16.
//  Copyright © 2016 Carine Iskander. All rights reserved.
//

import Foundation

class LetterSequenceToken : Token
{
    fileprivate var _letters : String
    var Letters : String { get {return _letters}}
    
    init(letters: String)
    {
        _letters = letters.uppercased()
        super.init()
    }
    
    // TODO : Refact Claim.Stake to not throw and use fatal error instead
    override func MatchSequential(_ candidate: Candidate) throws -> Bool
    {
        // No second tries
        if (_previousClaim != nil)
        {
            return false;
        }
        
        let next = candidate.GetNextUnused(_letters.characters.count)
        if(next.ClaimedText(candidate.Word) == _letters)
        {
            candidate.Stake(next)
            _previousClaim = next
            return true
        }
        return false
    }
    
    override func MatchAny(_ candidate: Candidate) throws -> Bool
    {
        throw PatternError.invalidTokenInAnagram
    }
    
    override func GetLengthOfMatches(_ min: inout Int, max: inout Int)
    {
        min = _letters.characters.count
        max = _letters.characters.count
    }
    
    override func ExplainInEnglish() -> String?
    {
        return NSString(format: "the letters %s in sequence", _letters) as String
    }
    
    override func MergeWith(_ second: Token, inAnagram: Bool) -> Token?
    {
        
        if (!inAnagram && second is LetterToken)
        {
            var str = _letters
            str.append(String((second as! LetterToken).Letter))
            return LetterSequenceToken(letters: str)
        }
        return nil
    }
    
    override func GetPrefix() -> String?
    {
        return _letters
    }
}
