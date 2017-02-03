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
        
        repeat{
            try _tokenStack.append(TokenFactory.CreateToken(pattern: raw, startIndex: &index))
        }while (index < end)
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
    
}
