//
//  DotSequenceToken.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 1/11/17.
//  Copyright © 2017 Carine Iskander. All rights reserved.
//

import Foundation

class DotSequenceToken : DotToken
{
    private var _length : Int
    
    init(length : Int)
    {
        _length = length
        super.init(tokenChar: ".")
    }
    
    override func MatchSequential(candidate: Candidate) -> Bool
    {
        // No second tries
        if (_previousClaim != nil)
        {
            return false;
        }
        
        let next = candidate.GetNextUnused(_length)
        if(!next.IsEmpty() && DotToken.ObeysRules(".", str: next.ClaimedText(candidate.Word)))
        {
            candidate.Stake(next)
            _previousClaim = next
            return true
        }
        return false
    }
    
    override func MatchAny(candidate: Candidate) -> Bool
    {
        fatalError("We never merge dot tokens in anagrams")
    }
    
    override func GetLengthOfMatches(inout min: Int, inout max: Int)
    {
        min = _length
        max = _length
    }
    
    override func ExplainInEnglish() -> String?
    {
        return NSString(format: "any %d letters", _length) as String
    }

    override func MergeWith(second: Token, inAnagram: Bool) -> Token?
    {
        
        if (!inAnagram && second is DotToken)
        {
            return DotSequenceToken(length: _length + 1)
        }
        return nil
    }
}