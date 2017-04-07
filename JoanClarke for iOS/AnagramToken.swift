//
//  AnagramToken.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 3/22/17.
//  Copyright © 2017 Carine Iskander. All rights reserved.
//

import Foundation

class AnagramToken : Token
{
    fileprivate var _childTokenStack : [Token]
    
    init(pattern: String) throws
    {
        _childTokenStack = []
        
        var index = pattern.characters.startIndex
        let end = pattern.characters.endIndex

        while (index < end)
        {
            let child = try TokenFactory.CreateToken(pattern: pattern, startIndex: &index)
            if (child is AnagramToken)
            {
                throw PatternError.noNestedAnagram
            }
            
            child.InAnagram = true
            _childTokenStack.append(child)
        }

        super.init()

        OptimizeTokenOrder()
}
    
    private func OptimizeTokenOrder()
    {
        _childTokenStack.sort(by: { t1, t2 in return t1.SortRank() < t2.SortRank() })
    }
    
    override func MatchSequential(_ candidate: Candidate) throws -> Bool
    {
        // No second tries
        if (_previousClaim != nil)
        {
            return false;
        }
        
        var currentChild = 0
        while (currentChild < _childTokenStack.count)
        {
            let childToken = _childTokenStack[currentChild]
            let match = try childToken.MatchAny(candidate)
            if (match)
            {
                // This token matches
                currentChild += 1;
            }
            else
            {
                // This token didn't match. Popping it should clean it up.
                childToken.Pop(candidate)
                // Go back, and retry previous token, if any (it may be able to match variable lengths)
                currentChild -= 1
                if (currentChild < 0)
                {
                    // Popped all the way back to the beginning, so fail
                    return false
                }
            }
        }
        
        
        return true
    }
    
    override func MatchAny(_ candidate: Candidate) -> Bool
    {
        // Invalid to have an anagram inside another anagram
        return false
    }
    
    override func Pop(_ candidate: Candidate)
    {
        super.Pop(candidate)
        
        // If we've matched all o four tokens, then pop the entire stack to reset them
        for i in 0 ..< _childTokenStack.count
        {
            _childTokenStack[i].Pop(candidate)
        }
    }
    
    override func GetLengthOfMatches(_ min: inout Int, max: inout Int)
    {
        min = 0
        max = 0
        for i in 0 ..< _childTokenStack.count
        {
            var min2 = 0
            var max2 = 0
            _childTokenStack[i].GetLengthOfMatches(&min2, max: &max2)
            min += min2
            max += max2
        }
    }
    
    override func SortRank() -> Int
    {
        return 70
    }
    
    override func ExplainInEnglish() -> String?
    {
        var builder = ""
        var first = true
        for i in 0 ..< _childTokenStack.count
        {
            let english = _childTokenStack[i].ExplainInEnglish()
            if (english == nil)
            {
                continue
            }
            if (!first)
            {
                builder.append(" and ")
            }
            else
            {
                first = false
            }
            builder.append(english!)
        }
        
        if (builder.isEmpty)
        {
            return nil
        }
        builder.append(" in any order")
        
        return "an anagram of " + builder
    }
}
