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
    private var _letterCounts = [Character: Int]()
    var Letters : String?
        {
            get
            {
                var str = ""
                for ch in _letterCounts.keys
                {
                    var count = _letterCounts[ch]
                    while (count != nil && count!-- > 0)
                    {
                        str.append(ch)
                    }
                }
                return str
            }
        }
    
    private var _exclusive : Bool
    var Exclusive : Bool { get { return _exclusive }}
    
    init(str: String?, exclusive: Bool)
    {
        _exclusive = exclusive
        if (str != nil)
        {
            let lower = str!.lowercaseString.characters
            for ch in lower
            {
                var count = _letterCounts[ch]
                if (count == nil)
                {
                    count = 0;
                }
                _letterCounts[ch] = ++count!
            }
        }
    }
    
    /// Is a letter in the letter set?
    func IsInSet(ch: Character) -> Bool
    {
        // TODO: convert ch to lowercase
        let count = _letterCounts[ch]
        return count != nil && count! > 0
    }
    
    /// Are all the letters in the string in the letter set
    func AreAllInSet(str: String) -> Bool
    {
        let lower = str.lowercaseString.characters
        for ch in lower
        {
            if (!IsInSet(ch))
            {
                return false
            }
        }
        return true
    }
    
    func Reserve(str : String) throws
    {
        // Base class does nothing
    }
    
    func Return(str: String)
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
    private func IsCountInSet(ch: Character, count: Int) -> Bool
    {
        let countInSet = _letterCounts[ch]
        return countInSet != nil && countInSet! >= count
    }
    
    /// Are all the letters from the string in the letter set (enough times)
    override func AreAllInSet(str: String) -> Bool
    {
        var letters = [Character: Int]()
        let lower = str.lowercaseString.characters
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
            if (!IsCountInSet(ch, count: ++count!))
            {
                return false;
            }
            
            letters[ch] = count
        }
        
        return true
    }
    
    ///
    private func ReserveChar(ch: Character) throws
    {
        var count = _letterCounts[ch]
        if (count == nil || count! == 0)
        {
            throw PatternError.CannotReserveLetter
        }
        _letterCounts[ch] = --count!
    }
    
    /// Exhaust one character from our exhaustible letter set
    override func Reserve(str: String) throws
    {
        let lower = str.lowercaseString.characters
        for ch in lower
        {
            try ReserveChar(ch)
        }
    }
    
    /// Un-exhaust characters back into our exhaustible letter set
    override func Return(str: String)
    {
        let lower = str.lowercaseString.characters
        for ch in lower
        {
            // If we've counted this letter before, get the previous count
            var count = _letterCounts[ch]
            if (count == nil)
            {
                // This is the first time we've seen this letter, so previous count = 0
                count = 0
            }
            
            _letterCounts[ch] = ++count!
        }

    }
}
