//
//  StarToken.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 3/8/17.
//  Copyright © 2017 Carine Iskander. All rights reserved.
//

import Foundation

class StarToken : Token
{
    fileprivate static var _rule = Rule()
    
    static func ApplyRule(rule : Rule)
    {
        _rule = Rule(r: _rule, s: rule)
    }
    
    static func ClearRules()
    {
        _rule = Rule()
    }

    
    static func ObeysRules(claim: Claim, candidate: Candidate) -> Bool
    {
        return _rule.ObeysRules(claim, candidate: candidate)
    }
    
    static func ReserveFromRule(str: String)
    {
        _rule.Reserve(str)
    }
    
    static func ReturnToRule(str: String)
    {
       _rule.Return(str)
    }
    
    override func MatchSequential(_ candidate: Candidate) -> Bool
    {
        var claim = _previousClaim
        // Star is variable length, so keep trying with ever smaller sets until one is valid
        while(claim == nil || !(claim!.IsEmpty()))
        {
            if (claim == nil)
            {
                // First time, optimistically grab all remaining chars
                claim = candidate.GetAllRemaining()
            }
            else if(!(claim!.IsEmpty()))
            {
                // Successive times, drop the last character from the previous set
                claim = claim!.UnclaimLast()
            }
            
            // After the first time, return any letter sets we claimed
            if (_previousClaim != nil)
            {
                StarToken.ReturnToRule(str: _previousClaim!.ClaimedText(candidate.Word))
            }
            
            if (StarToken.ObeysRules(claim: claim!, candidate: candidate))
            {
                // This substring obeys all rules.
                // Before we can claim it, unclaim any previous iteration
                if (_previousClaim != nil && _previousClaim != Claim.Empty)
                {
                    candidate.Free(_previousClaim!)
                }
                
                // Now it's safe to claim it
                StarToken.ReserveFromRule(str: claim!.ClaimedText(candidate.Word))
                _previousClaim = claim!
                candidate.Stake(claim!)
                return true
            }
        }
        
        // No substring obeyed all the rules -- not even the empty substring
        return false
    }
    
    override func MatchAny(_ candidate: Candidate) -> Bool
    {
        if( _previousClaim != nil)
        {
            return false
        }
            
        let claim = candidate.GetAllRemaining()
        if (!StarToken.ObeysRules(claim: claim, candidate: candidate))
        {
            return false
        }
        
        candidate.Stake(claim)
        StarToken.ReserveFromRule(str: claim.ClaimedText(candidate.Word))
        _previousClaim = claim
        return true
    }
    
    override func Pop(_ candidate: Candidate)
    {
        if (_previousClaim != nil)
        {
            StarToken.ReturnToRule(str: _previousClaim!.ClaimedText(candidate.Word))
        }
        super.Pop(candidate)
    }
    
    override func GetLengthOfMatches(_ min: inout Int, max: inout Int)
    {
       StarToken._rule.GetMinMaxLength(&min, max: &max)
    }
    
    override func SortRank() -> Int
    {
        return 50
    }
    
    override func ExplainInEnglish() -> String?
    {
        return "anything"
    }
}
