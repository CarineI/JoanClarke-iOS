//
//  Candidate.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 10/5/16.
//  Copyright © 2016 Carine Iskander. All rights reserved.
//

import Foundation

class Candidate
{
    private var _word : String
    var Word : String { get { return _word}}
    
    private var _previousLink : Candidate?
    var PreviousLink : Candidate? { get { return _previousLink } }
    
    private var _alreadyClaimed : Claim
    
    init(word : String, previousLink : Candidate? = nil)
    {
        _word = word
        _previousLink = previousLink
        _alreadyClaimed = Claim(maxLength: word.characters.count)
    }
    
    func WordIndex() -> Int
    {
        var index : Int = 0
        var c : Candidate? = _previousLink
        while ( c != nil)
        {
            index++
            c = c!._previousLink
        }
        return index
    }
    
    /// Mark part of a candidate as used
    func Stake(stake: Claim)
    {
        VerifyElseCrash(!_alreadyClaimed.DoClaimsOverlap(stake))
        _alreadyClaimed = Claim.CombineClaims(_alreadyClaimed, b: stake)
    }

    /// Release part of candidate that was staked
    func Free(stake: Claim)
    {
        VerifyElseCrash(stake.IsSubclaimOf(_alreadyClaimed))
        _alreadyClaimed = Claim.SeparateClaims(_alreadyClaimed, b: stake)
    }
    
    /// Returns a claim with all unused letters(characters)
    func GetAllRemaining() -> Claim
    {
        return _alreadyClaimed.AllUnclaimedCharacters()
    }
    
    /// Returns the next letter(character) that is not already staked
    func GetNextUnused(previous: Claim? = nil) -> Claim
    {
        return _alreadyClaimed.NextUnclaimedCharacter(previous)
    }
    
    /// Returns the next set of unused letters(characters) as requested
    func GetNextUnused(length: Int) -> Claim
    {
        return _alreadyClaimed.NextUnclaimedCharacter(length)
    }
    
    /// Returns a matching unstaked letter within this candidate, if any exist
    func Find(ch: Character) -> Claim
    {
        return Find(nil, ch: ch)
    }
    
    /// Returns a matching unstaked letter within this candidate if any exist
    /// starting after the given claim
    func Find(previous : Claim?, ch: Character) -> Claim
    {
        var single = _alreadyClaimed.NextUnclaimedCharacter(previous)
        while(!single.IsEmpty())
        {
            let claimedWordText = single.ClaimedText(_word)
            let chInString = String(ch)
            if (claimedWordText.caseInsensitiveCompare(chInString) == NSComparisonResult.OrderedSame)
            {
              return single
            }
            single = _alreadyClaimed.NextUnclaimedCharacter(single)
        }
        return single // which is empty
    }
}