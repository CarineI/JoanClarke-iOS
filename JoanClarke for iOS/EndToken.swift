//
//  EndToken.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 2/2/17.
//  Copyright © 2017 Carine Iskander. All rights reserved.
//

import Foundation

class EndToken : Token
{
    override func MatchSequential(_ candidate: Candidate) -> Bool
    {
        if (_previousClaim != nil)
        {
            return false
        }
        
        let claim = candidate.GetAllRemaining()
        if (!claim.IsEmpty())
        {
            return false
        }
        
        _previousClaim = claim
        candidate.Stake(claim)
        
        return true //TBD rules
    }
    
    override func MatchAny(_ candidate: Candidate) -> Bool {
        return MatchSequential(candidate)
    }
    
    override func SortRank() -> Int {
        return 100
    }
}
