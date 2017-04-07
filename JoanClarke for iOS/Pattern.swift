//
//  Pattern.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 2/2/17.
//  Copyright © 2017 Carine Iskander. All rights reserved.
//

import Foundation

class Pattern
{
    fileprivate var _raw : String
    
    fileprivate var _tokenStack : [Token]

    init(raw : String) throws
    {
        _raw = raw
        _tokenStack = []
        
        var index = raw.characters.startIndex
        let end = raw.characters.endIndex
        
        while (index < end)
        {
            try _tokenStack.append(TokenFactory.CreateToken(pattern: raw, startIndex: &index))
        }
        _tokenStack.append(TokenFactory.CreateEndToken(pattern: raw))
        
        
        // optimize
        var i = 0
        while (i < (_tokenStack.count - 1))
        {
            let merge = _tokenStack[i].MergeWith(_tokenStack[i+1], inAnagram: false)
            if (merge != nil)
            {
                _tokenStack[i] = merge!
                _tokenStack.remove(at: i + 1)
            }
            else
            {
                i += 1;
            }
        }
    }
    
    func Match(word: String) throws  -> Bool
    {
        let candidate = Candidate(word: word)
        
        var progress = 0
        
        while (progress < _tokenStack.count)
        {
            let token = _tokenStack[progress]
            let match = try token.MatchSequential(candidate)
            if (match)
            {
                progress += 1
            }
            else
            {
                token.Pop(candidate)
                progress -= 1
                if (progress < 0)
                {
                    return false
                }
            }
        }
        
        while (progress > 0)
        {
            progress -= 1
            _tokenStack[progress].Pop(candidate)
        }
        
        return true
    }

    func WordLengthOfMatches(minLength: inout Int, maxLength: inout Int)
    {
        minLength = 0
        maxLength = 0
        var min = 0
        var max = 0
        for i in 0..<_tokenStack.count
        {
            _tokenStack[i].GetLengthOfMatches(&min, max: &max)
            minLength += min
            maxLength += max
        }
        
        // todo : deal with rules hanging off endtoken
        
    }

    func ExplainInEnglish() -> String
    {
        var length : String
        var minLength = 0
        var maxLength = 0
        
        WordLengthOfMatches(minLength: &minLength, maxLength: &maxLength)
        if (minLength == maxLength)
        {
            length = String(format: "Words of length %d", minLength)
        }
        else if (maxLength >= 1000)
        {
            length = String(format: "Words of at least length %d", minLength)
        }
        else
        {
            length = String(format: "Words between %d and %d letters long", minLength, maxLength)
        }
        
        
        var first = true
        var builder = length + "\n"
        for i in 0..<_tokenStack.count
        {
            let english = _tokenStack[i].ExplainInEnglish()
            if( english == nil)
            {
                continue;
            }
            
            if (_tokenStack.count == 1)
            {
                builder.append("which contain")
            }
            else if (first)
            {
                builder.append("which start with " + english! + "\n")
                first = false
            }
            else
            {
                builder.append("followed by " + english! + "\n")
            }
        }
        
        // add multiword support here
        
        return builder
    }
    
}
