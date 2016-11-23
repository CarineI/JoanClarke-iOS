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
    private var _letters : String
    var Letters : String { get {return _letters}}
    
    init(letters: String)
    {
        _letters = letters.uppercaseString
        super.init()
    }
    
    // TODO : Refact Claim.Stake to not throw and use fatal error instead
    override func MatchSequential(candidate: Candidate) throws -> Bool
    {
        // No second tries
        if (_previousClaim != nil)
        {
            return false;
        }
        
        let next = candidate.GetNextUnused(_letters.characters.count)
        if(next.ClaimedText(candidate.Word) == _letters)
        {
            try candidate.Stake(next)
            _previousClaim = next
            return true
        }
        return false
    }
    
    override func MatchAny(candidate: Candidate) throws -> Bool
    {
        throw PatternError.InvalidTokenInAnagram
    }
    
    override func GetLengthOfMatches(inout min: Int, inout max: Int)
    {
        min = _letters.characters.count
        max = _letters.characters.count
    }
    
    override func ExplainInEnglish() -> String?
    {
        return NSString(format: "the letters %s in sequence", _letters) as String
    }
    
    override func MergeWith(second: Token, inAnagram: Bool) -> Token?
    {
        
        if (!inAnagram && second is LetterToken)
        {
            var str = _letters
            str.appendContentsOf(String((second as! LetterToken).Letter))
            return LetterSequenceToken(letters: str)
        }
        return nil
    }
    
    override func GetPrefix() -> String?
    {
        return _letters
    }
}