//
//  LetterToken.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 11/10/16.
//  Copyright © 2016 Carine Iskander. All rights reserved.
//

import Foundation

class LetterToken : Token
{
    private var _letter : String
    var Letter : Character { get {return _letter.characters.first!}}
    
    init(letter: Character)
    {
        _letter = String(letter).uppercaseString
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
        
        let next = candidate.GetNextUnused()
        if(next.ClaimedText(candidate.Word) == _letter)
        {
            try candidate.Stake(next)
            _previousClaim = next
            return true
        }
        return false
    }
    
    override func MatchAny(candidate: Candidate) throws -> Bool
    {
        let match = candidate.Find(_previousClaim, ch: Letter)
        if (!match.IsEmpty())
        {
            if( _previousClaim != nil)
            {
               try candidate.Free(_previousClaim!)
            }
            
            try candidate.Stake(match)
            _previousClaim = match
            return true
        }
        return false
    }
    
    override func GetLengthOfMatches(inout min: Int, inout max: Int)
    {
        min = 1
        max = 1
    }
    
    override func ExplainInEnglish() -> String?
    {
        return NSString(format: "the letter %s", _letter) as String
    }
    
    override func MergeWith(second: Token, inAnagram: Bool) -> Token?
    {
        // TODO: after letter sequence
        
        return nil
    }
    
    override func GetPrefix() -> String?
    {
        return _letter
    }
}