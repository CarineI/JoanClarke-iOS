//
//  Rule.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 10/26/16.
//  Copyright © 2016 Carine Iskander. All rights reserved.
//

import Foundation

class Rule
{
    static func ClearAllRules()
    {
        // clear rules for token types
    }
    
    static func ApplyAllRules()
    {
        // take in list of rules
        // apply each rule
    }
    
    private var _tokenChars : String
    private var _unique: Bool?
    private var _minLength: Int?
    private var _maxLength: Int?
    private var _cryptoRedefine: Bool
    private var _dotRedefine: Bool
    private var _letterSet: LetterSet?
    
    var Letters : LetterSet? { get { return _letterSet } }
    var MinLength : Int? { get { return _minLength } }
    var MaxLength : Int? { get { return _maxLength } }
    var IsCryptoRedefine  : Bool { get { return _cryptoRedefine } }
    var IsDotRedefine : Bool { get { return _dotRedefine } }
    
    init()
    {
        // false by default
        _cryptoRedefine = false
        _dotRedefine = false
        _tokenChars = ""
    }
    
    convenience init(raw: String) throws
    {
        self.init()

        try ParseRule(raw)
    }
    
    convenience init(r: Rule, s: Rule)
    {
        self.init()
        _minLength = Merge(r._minLength, b: s._minLength, minimum: true)
        _maxLength = Merge(r._maxLength, b: s._maxLength, minimum: false)
        _unique = Merge(r._unique, b: s._unique)
        _letterSet = Merge(r._letterSet, b: s._letterSet)
        _cryptoRedefine = r._cryptoRedefine || s._cryptoRedefine
        _dotRedefine = r._dotRedefine || s._dotRedefine
    }
    
    private func ParseRule(raw: String) throws
    {
        let iEquals = raw.characters.indexOf("=")!
        
        var left = raw.substringToIndex(iEquals)
        var right = raw.substringFromIndex(iEquals.advancedBy(1))
        var op = "="
        
        let lastLeft = left.characters.last
        let firstRight = right.characters.first
        
        if ( lastLeft != nil  &&  (lastLeft! == "<"  || lastLeft! == ">" || lastLeft! == "!"))
        {
            op = raw.substringWithRange(iEquals.advancedBy(-1)...iEquals)
            left = left.substringToIndex(iEquals.advancedBy(-1))
        }
        else if ( firstRight != nil  &&  (firstRight! == "<"  || firstRight! == ">"))
        {
            op = raw.substringWithRange(iEquals.advancedBy(1)...iEquals.advancedBy(1))
            right = raw.substringFromIndex(iEquals.advancedBy(2))
        }
        else if ( firstRight != nil  &&  firstRight! == "=")
        {
            op = "=="
            right = raw.substringFromIndex(iEquals.advancedBy(2))
        }
        
        if (left.characters.count < 1)
        {
            throw PatternError.RuleMustSpecifyTokenCharacter
        }
        if (right.characters.count == 0)
        {
            throw PatternError.UnfinishedRule
        }
        
        _tokenChars = Rule.Expand(left)
        
        // Parse length rules
        if (op != "=" && op != "!=")
        {
            let length = Int(right)
            if (length == nil)
            {
                throw PatternError.LengthRulesRequireAnIntegerLength
            }
            
            switch op
            {
                case "==":
                   _minLength = length
                    _maxLength = length
                case "<=":
                    _maxLength = length
                case "<":
                    _maxLength = length! - 1
                case ">":
                    _minLength = length! + 1
                case ">=":
                    _minLength = length
                default:
                    throw PatternError.LengthRulesRequireAnIntegerLength
                
            }
        }
        else if (right.characters.first! == "{")
        {
            // Parse letter set rules
            if (right.characters.last! != "}")
            {
                throw PatternError.MismatchedBraces
            }
            
            let start = right.startIndex.advancedBy(1)
            let end = right.endIndex.advancedBy(-1)
            var letters = right.substringWithRange(start..<end)
            let exclusive = (letters.characters.count > 0 && letters.characters.first! == "!")
            if (exclusive)
            {
                letters = letters.substringFromIndex(letters.startIndex.advancedBy(1))
            }
            _letterSet = LetterSet(str: letters, exclusive: exclusive)
        }
        else if (right.characters.first! == "[")
        {
            // Parse letter set rules
            if (right.characters.last! != "]")
            {
                throw PatternError.MismatchedBraces
            }
            
            let start = right.startIndex.advancedBy(1)
            let end = right.endIndex.advancedBy(-1)
            let letters = right.substringWithRange(start...end)
            _letterSet = ExhaustibleLetterSet(str: letters)
        }
        else if (right == "^" || right == "!~" || (right == "~" && op == "!="))
        {
            // Three different expressions for unique
            _unique = true;
        }
        else if (right == "~" || right == "!^" || (right == "^" && op == "!="))
        {
            // Three different expressions for not unique
            _unique = false;
        }
        else if (right == "0")
        {
            _cryptoRedefine = true
        }
        else if (right == ".")
        {
            _dotRedefine = true
        }
        else
        {
            throw PatternError.UnknownRule
        }
    }
    
    static func Expand(tokens : String) -> String
    {
        // TODO: write code to expand "a-c" to "abc", etc.
        if (tokens.characters.indexOf(",") != nil)
        {
            let toks = tokens.characters.split(",")
            var expanded = ""
            for tok in toks
            {
                expanded.appendContentsOf(Expand(String(tok)))
            }
            return expanded
        }
        
        // the windows version has an @ number expander
        
        let one = tokens.characters.startIndex.advancedBy(1)
        if (tokens.characters.count == 3 && tokens.substringWithRange(one...one) == "-")
        {
            var expanded = ""
            let firstInt = tokens.utf16.first!
            let lastInt = tokens.utf16.last!
            for ch in firstInt...lastInt
            {
                expanded.append(UnicodeScalar(ch))
            }
            return Expand(expanded)
        }
        
        return tokens
    }
    
    /// Does this rule override uniqueness? If not, return the default passed in from the token
    func IsUnique(defaultIfUnset: Bool = true) -> Bool
    {
        return _unique == nil ? defaultIfUnset : _unique!
    }
    
    /// If this rule has a letter set, does this character pass? If no letter set, all characters pass.
    func IsInSet(ch: Character) -> Bool
    {
        return _letterSet == nil ? true : _letterSet!.IsInSet(ch)
    }
    
    /// If this rule has a letter set, do the characters in this string pass? If no letter set, all characters pass.
    func AreAllInSet(str: String) -> Bool
    {
        return _letterSet == nil ? true : _letterSet!.AreAllInSet(str)
    }
    
    /// If this rule has a exhaustible letter set, reserve these letters. If no letter set, this is a no-op.
    func Reserve(str: String)
    {
        if (_letterSet != nil)
        {
             _letterSet!.Reserve(str)
        }
    }
    
    /// If this rule has a exhaustible letter set, return these letters. If no letter set, this is a no-op.
    func Return(str: String)
    {
        if (_letterSet != nil)
        {
             _letterSet!.Return(str)
        }
    }
    
    /// If this rule specifies length constraints, does this length pass? If no constraints are set, all lengths pass
    func IsValidLength(length: Int) -> Bool
    {
        if (_minLength != nil && _minLength! > length)
        {
            return false
        }
        if (_maxLength != nil && _maxLength! < length)
        {
            return false
        }
        return true
    }
    
    /// What are the length constraints. If none are set, the defaults are 0...1000
    func GetMinMaxLength(inout min: Int, inout max: Int)
    {
        min = _minLength == nil ? 0 : _minLength!
        max = _maxLength == nil ? 1000 : _maxLength!
    }
    
    /// Checks if this claim is compliant with the rules
    func ObeysRules(claim: Claim, candidate : Candidate) -> Bool
    {
        // If we have a minLength rule and we have violated it
        if (_minLength != nil && claim.Length() < _minLength)
        {
            return false
        }
        // If we have a maxLength rule and we have violated it
        if (_maxLength != nil && claim.Length() > _maxLength)
        {
            return false
        }
        // If a LetterSet is set, all the claimed text must exist in that set
        if (_letterSet !=  nil && !_letterSet!.AreAllInSet(claim.ClaimedText(candidate.Word)))
        {
            return false
        }
        
        // otherwise, we're compliant
        return true
    }
    
    /// Merge two ints by taking the non-nil one, or the min/max if they're both non-nil
    private func Merge(a: Int?, b: Int?, minimum: Bool) -> Int?
    {
        if (a == nil)
        {
            return b
        }
        if (b == nil)
        {
            return a
        }
        return minimum ? min(a!, b!) : max(a!, b!)
    }
    
    /// Merge two bools by taking the non-nil one, or oring/anding them if they're both non-nil
    private func Merge(a: Bool?, b: Bool?, or: Bool = true) -> Bool?
    {
        if (a == nil)
        {
            return b
        }
        if (b == nil)
        {
            return a
        }
        return or ? (a! || b!) : (a! && b!)
    }
    
    /// Merge two lettersets by taking the non-nil one, or b, if both are non-nil
    private func Merge(a: LetterSet?, b: LetterSet?) -> LetterSet?
    {
        if (a == nil)
        {
            return b
        }
        return a
    }
}