//
//  LetterSet.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 10/14/16.
//  Copyright © 2016 Carine Iskander. All rights reserved.
//

import Foundation

class LetterSet
{
    fileprivate var _letterCounts = [Character: Int]()
    var Letters : String?
        {
            get
            {
                var str = ""
                for ch in _letterCounts.keys
                {
                    let count = _letterCounts[ch]
                    if (count != nil)
                    {
                        for _ in 0..<count!
                        {
                            str.append(ch)
                        }
                    }
                }
                return str
            }
        }
    
    fileprivate var _exclusive : Bool
    var Exclusive : Bool { get { return _exclusive }}
    
    init(str: String?, exclusive: Bool)
    {
        _exclusive = exclusive
        if (str != nil)
        {
            let lower = str!.lowercased().characters
            for ch in lower
            {
                var count = _letterCounts[ch]
                if (count == nil)
                {
                    count = 0;
                }
                count! += 1
                _letterCounts[ch] = count!
            }
        }
    }
    
    /// Is a letter in the letter set?
    func IsInSet(_ ch: Character) -> Bool
    {
        // TODO: convert ch to lowercase
        let count = _letterCounts[ch]
        return count != nil && count! > 0
    }
    
    /// Are all the letters in the string in the letter set
    func AreAllInSet(_ str: String) -> Bool
    {
        let lower = str.lowercased().characters
        for ch in lower
        {
            if (!IsInSet(ch))
            {
                return false
            }
        }
        return true
    }
    
    func Reserve(_ str : String)
    {
        // Base class does nothing
    }
    
    func Return(_ str: String)
    {
        // Base class does nothing
    }
}

class ExhaustibleLetterSet : LetterSet
{
    init(str: String) {
        super.init(str: str, exclusive: false)
    }
    
    /// Are there N (or more) instances of a character in this letter set
    fileprivate func IsCountInSet(_ ch: Character, count: Int) -> Bool
    {
        let countInSet = _letterCounts[ch]
        return countInSet != nil && countInSet! >= count
    }
    
    /// Are all the letters from the string in the letter set (enough times)
    override func AreAllInSet(_ str: String) -> Bool
    {
        var letters = [Character: Int]()
        let lower = str.lowercased().characters
        for ch in lower
        {
            // If we've counted this letter before, get the previous count
            var count = letters[ch]
            if (count == nil)
            {
                // This is the first time we've seen this letter, so previous count = 0
                count = 0
            }
            
            // Verify that there are enough instances of this letter in the set
            count! += 1
            if (!IsCountInSet(ch, count: count!))
            {
                return false;
            }
            
            letters[ch] = count
        }
        
        return true
    }
    
    ///
    fileprivate func ReserveChar(_ ch: Character)
    {
        var count = _letterCounts[ch]
        VerifyElseCrash(count == nil || count! > 0)
        count! -= 1
        _letterCounts[ch] = count!
    }
    
    /// Exhaust one character from our exhaustible letter set
    override func Reserve(_ str: String)
    {
        let lower = str.lowercased().characters
        for ch in lower
        {
            ReserveChar(ch)
        }
    }
    
    /// Un-exhaust characters back into our exhaustible letter set
    override func Return(_ str: String)
    {
        let lower = str.lowercased().characters
        for ch in lower
        {
            // If we've counted this letter before, get the previous count
            var count = _letterCounts[ch]
            if (count == nil)
            {
                // This is the first time we've seen this letter, so previous count = 0
                count = 0
            }
            
            count! += 1
            _letterCounts[ch] = count!
        }

    }
}
