//
//  DotToken.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 12/21/16.
//  Copyright © 2016 Carine Iskander. All rights reserved.
//

import Foundation


class DotToken : Token
{
    private var _token : String
    var TokenChar : Character { get {return _token.characters.first!}}
    private static var _ruleSets = [String : Rule]()
    
    init(tokenChar: Character)
    {
        _token = String(tokenChar)
        super.init()
    }
    
    static func ApplyRule(token: String, rule : Rule)
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
    
    static func ObeysRules(token: String, str: String) -> Bool
    {
        let r = _ruleSets[token]
        if( r == nil)
        {
            return true
        }
        else
        {
            return r!.AreAllInSet(str)
        }
    }
    
    static func ObeysRules(token: String, ch: Character) -> Bool
    {
        let r = _ruleSets[token]
        if( r == nil)
        {
            return true
        }
        else
        {
            return r!.IsInSet(ch)
        }
    }
    
    static func ReserveFromRule(token: String, str: String)
    {
        let r = _ruleSets[token]
        if (r != nil)
        {
           r!.Reserve(str)
        }
    }
    
    static func ReturnToRule(token: String, str: String)
    {
        let r = _ruleSets[token]
        if (r != nil)
        {
            r!.Return(str)
        }
    }

    override func MatchSequential(candidate: Candidate) -> Bool
    {
        // No second tries
        if (_previousClaim != nil)
        {
            return false;
        }
        
        let next = candidate.GetNextUnused()
        if(!next.IsEmpty() && DotToken.ObeysRules(_token, str: next.ClaimedText(candidate.Word)))
        {
            DotToken.ReserveFromRule(_token, str: next.ClaimedText(candidate.Word))
            candidate.Stake(next)
            _previousClaim = next
            return true
        }
        return false
    }
    
    override func MatchAny(candidate: Candidate) -> Bool
    {
        let match = candidate.GetNextUnused(_previousClaim)
        if (!match.IsEmpty() && DotToken.ObeysRules(_token, str: match.ClaimedText(candidate.Word)))
        {
            if( _previousClaim != nil)
            {
                DotToken.ReturnToRule(_token, str: _previousClaim!.ClaimedText(candidate.Word))
                candidate.Free(_previousClaim!)
            }
            
            DotToken.ReserveFromRule(_token, str: _previousClaim!.ClaimedText(candidate.Word))
            candidate.Stake(match)
            _previousClaim = match
            return true
        }
        return false
    }
    
    override func Pop(candidate: Candidate)
    {
        if (_previousClaim != nil)
        {
            DotToken.ReturnToRule(_token, str: _previousClaim!.ClaimedText(candidate.Word))
        }
    }
    
    override func GetLengthOfMatches(inout min: Int, inout max: Int)
    {
        min = 1
        max = 1
    }
    
    override func SortRank() -> Int
    {
        return 3
    }
    
    override func ExplainInEnglish() -> String?
    {
        return "any letter"
    }
    
    override func MergeWith(second: Token, inAnagram: Bool) -> Token?
    {
        // TODO: DotSequenceToken
        return nil
    }
}