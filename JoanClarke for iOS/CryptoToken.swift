//
//  CryptoToken.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 4/19/17.
//  Copyright © 2017 Carine Iskander. All rights reserved.
//

import Foundation

class CryptoToken : Token
{
    fileprivate var _codedCharacter : String
    fileprivate static var _ruleSets = [String : Rule]()
    fileprivate static var _dataMap = [String : CryptoData] ()
    fileprivate var _holdsRefCount : Bool
    
    init(codedCharacter: Character)
    {
        _codedCharacter = String(codedCharacter)
        _holdsRefCount = false
        super.init()
    }
    
    static func IsToken(ch : String) -> Bool
    {
        return  ch.characters.count == 1 &&
            (NSCharacterSet.decimalDigits.contains(ch.unicodeScalars.first!) || (_ruleSets[ch] != nil))
    }
    
    static func ApplyRule(_ token: String, rule : Rule)
    {
        let r = _ruleSets[token]
        if (r == nil)
        {
            _ruleSets[token] = rule
        }
        else
        {
            _ruleSets[token] = Rule(r: r!, s: rule)
        }
    }
    
    static func ClearRules()
    {
        _ruleSets = [String : Rule]()
    }
    
    static func ObeysRules(_ codedChar: String, ch: Character) -> Bool
    {
        let r = _ruleSets[codedChar]
        if( r != nil)
        {
            if (!r!.IsInSet(ch))
            {
                return false
            }
            
            if (!r!.IsUnique())
            {
                return true
            }
        }
        
        // When no rule is set, unique is assumed
        for key in _dataMap.keys
        {
            // don't compare with ourselves
            if (key == codedChar)
            {
                continue
            }
            
            let data = _dataMap[key]!
            // don't worry about any cryptos currently unassigned
            if (data._refCount == 0)
            {
                continue
            }
            
            // if we match an assigned crypto, then we're a duplicate
            if (data._decodedCharacter.characters.first! == ch)
            {
                return false
            }
        }
        
        // no duplicates found
        return true
    }
    
    static func ReserveFromRule(_ token: String, str: String)
    {
        let r = _ruleSets[token]
        if (r != nil)
        {
            r!.Reserve(str)
        }
    }
    
    static func ReturnToRule(_ token: String, str: String)
    {
        let r = _ruleSets[token]
        if (r != nil)
        {
            r!.Return(str)
        }
    }
    
    override func MatchSequential(_ candidate: Candidate) -> Bool
    {
        // No second tries
        if (_previousClaim != nil)
        {
            return false;
        }
        
        let data = CryptoToken._dataMap[_codedCharacter]!
        data._refCount += 1
        _holdsRefCount = true
        
        
        let next = candidate.GetNextUnused()
        if(next.IsEmpty())
        {
            return false
        }
        
        let letter = next.ClaimedText(candidate.Word).uppercased()
            
        if (data._refCount == 1)
        {
            // Currently unassigned
            if (!CryptoToken.ObeysRules(_codedCharacter, ch: letter.characters.first!))
            {
                return false
            }
            
            // on the first of this code character, it can match anything - save the match
            data._decodedCharacter = letter
            

        }
        else
        {
            // subsequent uses of this code character must match the first use
            if (letter != data._decodedCharacter)
            {
                return false
            }
        }
       
        
        _previousClaim = next
        candidate.Stake(next)
        return true
    }
    
    override func MatchAny(_ candidate: Candidate) -> Bool
    {
        var previous = _previousClaim
        let data = CryptoToken._dataMap[_codedCharacter]!
        if (_previousClaim == nil)  // refcount is redundant if we've already claimed
        {
            data._refCount += 1
            _holdsRefCount = true
        }
        
        if (data._refCount == 1)
        {
            // The first use of this code gets to pick any letter
            while (true)
            {
                // We must match a valid character
                let next = candidate.GetNextUnused(previous)
                if (next.IsEmpty())
                {
                    return false
                }
                
                let letter = next.ClaimedText(candidate.Word).uppercased()
                // Each crypto code must map to a unique letter,
                // so if this letter is already associated with a different code, fail
                if (CryptoToken.ObeysRules(_codedCharacter, ch: letter.characters.first!))
                {
                    // On the first use of this code character it can match anything - save the match
                    data._decodedCharacter = letter
                    
                    if (_previousClaim != nil)
                    {
                        candidate.Free(_previousClaim!)
                    }
                    
                    candidate.Stake(next)
                    _previousClaim = next
                    return true
                }
                    
                previous = next
            }
        }
        else
        {
            // subsequent uses of the code must match
            let letter = data._decodedCharacter
            let match = candidate.Find(_previousClaim, ch: letter.characters.first!)
            if (!match.IsEmpty())
            {
                if (_previousClaim != nil)
                {
                    candidate.Free(_previousClaim!)
                }
                
                candidate.Stake(match)
                _previousClaim = match
                return true
            }
            
            // No more letters matching our code
            return false
        }
    }
    
    override func Pop(_ candidate: Candidate)
    {
       if (_holdsRefCount)
       {
            let data = CryptoToken._dataMap[_codedCharacter]!
            data._refCount -= 1
            _holdsRefCount = false
        
            // We don't need to release the decodedCharacter when refCount == 0,
            // because the first refcount use always overwrites it.
        }
        super.Pop(candidate)
    }
    
    override func GetLengthOfMatches(_ min: inout Int, max: inout Int)
    {
        min = 1
        max = 1
    }
    
    override func SortRank() -> Int
    {
        return 2
    }
    
    override func ExplainInEnglish() -> String?
    {
        return String(format: " a letter (%@) that matches any other (%@)", _codedCharacter)
    }

    override func GetPrefix() -> String?
    {
        let data = CryptoToken._dataMap[_codedCharacter]
        return (data == nil || data!._refCount == 0) ? nil : data!._decodedCharacter
    }
    
    class CryptoData
    {
        var _refCount : Int
        var _decodedCharacter : String
        
        init()
        {
            _refCount = 0
            _decodedCharacter = ""
        }
    }
}
