//
//  Token.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 11/10/16.
//  Copyright © 2016 Carine Iskander. All rights reserved.
//

import Foundation

class Token
{
    var _previousClaim : Claim?
    var InAnagram : Bool
    
    init()
    {
        InAnagram = false
    }
    
    /// Must be overriden: match in non-anagram case
    func MatchSequential(candidate: Candidate) throws -> Bool
    {
        fatalError(" Must override")
    }
    
    /// Must be overriden: match in anagram case
    func MatchAny(candidate: Candidate) throws -> Bool
    {
        fatalError(" Must override")
    }
    
    /// Unclaim any staked claims of this token
    func Pop(candidate: Candidate)
    {
        if (_previousClaim == nil)
        {
            return
        }
        
        if (_previousClaim! != Claim.Empty)
        {
            
            candidate.Free(_previousClaim!)
        }
        
        _previousClaim = nil
    }
    
    /// Determines which tokens to process first inside an anagram
    func SortRank() -> Int
    {
        return 1
    }
    
    /// Comparer for sort ranks
    func CompareTo(token : Token) -> Int
    {
        return SortRank() - token.SortRank()
    }
    
    /// Friendly text for this token's claim
    func GetInterestingExpansion(candidateWord : String) -> String
    {
        return ""
    }
    
    /// TODO: Get multiword token results
    //func GetLinkedResults() -> SearchResults?
    //{
    //    return nil
    //}
    
    /** Specifies min and max letters matchable by token.
        Used to constrain dictionary search to words of
        appropriate length
    **/
    func GetLengthOfMatches(inout min : Int, inout max : Int)
    {
        min = 0
        max = 0
    }
    
    /// Friendly text used to describe pattern
    func ExplainInEnglish() -> String?
    {
        return nil
    }
    
    /// Combine sequential tokens of the same kind into a superset token
    func MergeWith(second: Token, inAnagram : Bool) -> Token?
    {
        return nil
    }
    
    /// This exact letter or letter sequence that this tokens matches to, if any
    func GetPrefix() -> String?
    {
        return nil
    }
}