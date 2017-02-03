//
//  Claim.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 9/14/16.
//  Copyright © 2016 Carine Iskander. All rights reserved.
//

import Foundation

func VerifyElseCrash(_ b: Bool)
{
    if (!b)
    {
        var n : Bool?
        n = nil
        _ = n!
    }
}

class Claim : Equatable
{
    static fileprivate(set) var Empty : Claim = Claim(maxLength: 0)
    
    var _maxBits : Int = 0
    var _bits : UInt64 = 0
    static let One: UInt64 = 1
    
    init(maxLength: Int)
    {
        _maxBits = maxLength
        
        //TO DO:
        // validate maxlength is <= 64
    }
    
    convenience init(maxLength: Int, startIndex : Int, count: Int = 1)
    {
        self.init(maxLength : maxLength)
        
        for i in 0..<count
        {
            _bits |= Claim.One << (UInt64(startIndex + i))
        }
    }
    
    func ClaimedText(_ word: String) -> String
    {
        var builder = ""
        for i in 0..<_maxBits
        {
            if ((_bits & (Claim.One << UInt64(i))) != 0)
            {
                let offset = word.characters.index(word.startIndex, offsetBy: i)
                let end = word.characters.index(word.startIndex, offsetBy: i + 1)
                let range = offset..<end
                builder += word.substring(with: range)
            }
        }
        return builder
    }
    
    /// Finds the next x unclaimed characters
    func NextUnclaimedCharacter(_ previousSingleCharacter: Claim?) -> Claim
    {
        var firstBit: Int = 0
        if (previousSingleCharacter != nil)
        {
            firstBit = previousSingleCharacter!.FirstSetBit() + 1
        }
        
        for bit in firstBit..<_maxBits
        {
            if (!BitAt(bit))
            {
                return Claim(maxLength: _maxBits, startIndex: bit)
            }
        }
        
        // return the empty string
        return Claim(maxLength: _maxBits)
    }
    
    /// Finds the next x unclaimed characters
    func NextUnclaimedCharacter(_ countOfChars: Int) -> Claim
    {
        let nBits : UInt64 = (Claim.One << UInt64(countOfChars)) - 1
        if (countOfChars <= _maxBits)
        {
            for bit in 0...(_maxBits - countOfChars)
            {
                if (AllBitsAt(nBits, index: bit) == 0)
                {
                    return Claim(maxLength: _maxBits, startIndex: bit, count: countOfChars)
                }
            }
        }
        
        // return the empty string
        return Claim(maxLength: _maxBits)
    }
    
    /// Returns true if no letters are claimed
    func IsEmpty() -> Bool
    {
        return _bits == 0
    }
    
    /// Returns the number of claimed letters
    func Length() -> Int
    {
        var len : Int = 0
        var bits : UInt64 = _bits
        while bits != 0
        {
            bits &= (bits - 1)
            len += 1
        }
        return len
    }
    
    /// Returns the inverse of this claim
    /// All letters claimed by this claim become unclaimed, and vice versa
    func AllUnclaimedCharacters () -> Claim
    {
        let unclaimed = Claim(maxLength: _maxBits)
        unclaimed._bits = ~_bits & AllBitsOn()
        return unclaimed
    }
    
    /// Returns the index of the first letter not used by this claim
    func NextUnclaimedIndex (_ after: Int = -1) -> Int
    {
        for i  in (after+1)..<_maxBits
        {
            // 0x1 is the first letter of the claim
            if (!BitAt(i))
            {
                return i
            }
        }
        return -1
    }
    
    /// Return the index of the first claimed bit
    func FirstIndex() -> Int
    {
        return FirstSetBit()
    }

    /// Unclaim the last set bit
   func UnclaimLast() -> Claim
   {
        let c = Claim(maxLength: _maxBits)
        let index = LastSetBit()
        if ( index >= 0)
        {
            c._bits = _bits
            c.SetBit(index, on: false)
        }
        return c
    }
    
    /// Checks if this claim and the given claim share any claimed bits
    func DoClaimsOverlap (_ claim : Claim) -> Bool
    {
        return (_bits & claim._bits) != 0
    }
    
    /// Checks that all bits set in our claim are also set in the given parent claim
    func IsSubclaimOf (_ parent : Claim) -> Bool
    {
        return (_bits & ~parent._bits) == 0
    }
    
    
    /// Combine two claims
    static func CombineClaims(_ a: Claim, b: Claim) -> Claim
    {
        VerifyElseCrash(a._maxBits == b._maxBits)
        
        let combined = Claim(maxLength: a._maxBits)
        combined._bits = a._bits | b._bits
        return combined;
    }
    
    static func SeparateClaims(_ a: Claim, b: Claim) -> Claim
    {
        VerifyElseCrash(a._maxBits == b._maxBits)
        VerifyElseCrash(a.IsSubclaimOf(b) || b.IsSubclaimOf(a))
        
        let separated = Claim(maxLength: a._maxBits)
        separated._bits = a._bits ^ b._bits;
        return separated
    }
    
    /// returns the bit field for a consecutive range of characters
    fileprivate func AllBitsAt(_ nBits: UInt64, index: Int) -> UInt64
    {
        return (_bits >> UInt64(index)) & nBits
    }
    
    /// returns whether a bit at a given index is used
    fileprivate func BitAt(_ index: Int) -> Bool
    {
        return (_bits & (Claim.One << UInt64(index))) != 0
    }
    
    /// turn all bits on to mark all used
    fileprivate func AllBitsOn() -> UInt64
    {
        return UINT64_MAX >> UInt64(64 - _maxBits)
    }
    
    /// set bit at a given index
    fileprivate func SetBit(_ index : Int, on : Bool)
    {
        if (on)
        {
            _bits |= (Claim.One << UInt64(index))
        }
        else
        {
            _bits &= ~(Claim.One << UInt64(index))
        }
    }
    
    /// Return the index of the first claimed bit (optionally starting at N)
    fileprivate func FirstSetBit(_ after : Int = -1) -> Int
    {
        for i in (after + 1)..<_maxBits
        {
            if (BitAt(i))
            {
                return i;
            }
        }
        return -1
    }
    
    /// Return the index of the last claimed bit
    fileprivate func LastSetBit() -> Int
    {
        for i in stride(from: (_maxBits - 1), through: 0, by: -1)
        {
            if (BitAt(i))
            {
                return i;
            }
        }
        return -1
    }
    
    /// Return the index of the first unclaimed bit (optionally starting at N)
    fileprivate func FirstUnsetBit(_ after : Int = -1) -> Int
    {
        for i in (after + 1)..<_maxBits
        {
            if (!BitAt(i))
            {
                return i;
            }
        }
        return -1
    }
    
   
}


func == (lhs: Claim, rhs: Claim) -> Bool
{
    return lhs._maxBits == rhs._maxBits && lhs._bits == rhs._bits
    
}
