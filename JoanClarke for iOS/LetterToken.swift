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
    fileprivate var _letter : String
    var Letter : Character { get {return _letter.characters.first!}}
    
    init(letter: Character)
    {
        _letter = String(letter).uppercased()
        super.init()
    }
    
    override func MatchSequential(_ candidate: Candidate) -> Bool
    {
        // No second tries
        if (_previousClaim != nil)
        {
            return false;
        }
        
        let next = candidate.GetNextUnused()
        if(next.ClaimedText(candidate.Word) == _letter)
        {
            candidate.Stake(next)
            _previousClaim = next
            return true
        }
        return false
    }
    
    override func MatchAny(_ candidate: Candidate) -> Bool
    {
        let match = candidate.Find(_previousClaim, ch: Letter)
        if (!match.IsEmpty())
        {
            if( _previousClaim != nil)
            {
                candidate.Free(_previousClaim!)
            }
            
            candidate.Stake(match)
            _previousClaim = match
            return true
        }
        return false
    }
    
    override func GetLengthOfMatches(_ min: inout Int, max: inout Int)
    {
        min = 1
        max = 1
    }
    
    override func ExplainInEnglish() -> String?
    {
        return String(format: "the letter %@", _letter)
    }
    
    override func MergeWith(_ second: Token, inAnagram: Bool) -> Token?
    {
       if (!inAnagram && second is LetterToken)
       {
            var str = _letter
            str.append((second as! LetterToken)._letter)
            return LetterSequenceToken(letters: str)
       }
        
        return nil
    }
    
    override func GetPrefix() -> String?
    {
        return _letter
    }
}
