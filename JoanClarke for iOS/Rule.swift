//
//  Rule.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 10/26/16.
//  Copyright © 2016 Carine Iskander. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class Rule
{
    static func ClearAllRules()
    {
        // clear rules for token types
        DotToken.ClearRules()
        StarToken.ClearRules()
        CryptoToken.ClearRules()
    }
    
    static func ApplyAllRules(rules: [Rule])
    {
        ClearAllRules()
        
        // take in list of rules
        // apply each rule
        for rule in rules
        {
            rule.Apply()
        }
    }
    
    fileprivate var _tokenChars : String
    fileprivate var _unique: Bool?
    fileprivate var _minLength: Int?
    fileprivate var _maxLength: Int?
    fileprivate var _cryptoRedefine: Bool
    fileprivate var _dotRedefine: Bool
    fileprivate var _letterSet: LetterSet?
    
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
    
    fileprivate func ParseRule(_ raw: String) throws
    {
        let iEquals = raw.characters.index(of: "=")!
        let iAfter = raw.index(after: iEquals)
        
        var left = raw.substring(to: iEquals)
        var right = raw.substring(from: iAfter)
        var op = "="
        
        let lastLeft = left.characters.last
        let firstRight = right.characters.first
        
        if ( lastLeft != nil  &&  (lastLeft! == "<"  || lastLeft! == ">" || lastLeft! == "!"))
        {
            let iBefore = raw.index(before: iEquals)
            op = raw.substring(with: iBefore..<iAfter)
            left = left.substring(to: iBefore)
        }
        else if ( firstRight != nil  &&  (firstRight! == "<"  || firstRight! == ">"))
        {
            let iAfter2 = raw.index(after: iAfter)
            op = raw.substring(with: iAfter..<iAfter2)
            right = raw.substring(from: iAfter2)
        }
        else if ( firstRight != nil  &&  firstRight! == "=")
        {
            let iAfter2 = raw.index(after: iAfter)
            op = "=="
            right = raw.substring(from: iAfter2)
        }
        
        if (left.characters.count < 1)
        {
            throw PatternError.ruleMustSpecifyTokenCharacter
        }
        if (right.characters.count == 0)
        {
            throw PatternError.unfinishedRule
        }
        
        _tokenChars = Rule.Expand(left)
        
        // Parse length rules
        if (op != "=" && op != "!=")
        {
            let length = Int(right)
            if (length == nil)
            {
                throw PatternError.lengthRulesRequireAnIntegerLength
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
                    throw PatternError.lengthRulesRequireAnIntegerLength
                
            }
        }
        else if (right.characters.first! == "{")
        {
            // Parse letter set rules
            if (right.characters.last! != "}")
            {
                throw PatternError.mismatchedBraces
            }
            
            let start = right.characters.index(right.startIndex, offsetBy: 1)
            let end = right.characters.index(right.endIndex, offsetBy: -1)
            var letters = right.substring(with: start..<end)
            let exclusive = (letters.characters.count > 0 && letters.characters.first! == "!")
            if (exclusive)
            {
                letters = letters.substring(from: letters.characters.index(letters.startIndex, offsetBy: 1))
            }
            _letterSet = LetterSet(str: letters, exclusive: exclusive)
        }
        else if (right.characters.first! == "[")
        {
            // Parse letter set rules
            if (right.characters.last! != "]")
            {
                throw PatternError.mismatchedBraces
            }
            
            let start = right.index(after: right.startIndex)
            let end = right.index(before: right.endIndex)
            let letters = right.substring(with: start..<end)
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
            throw PatternError.unknownRule
        }
    }
    
    static func Expand(_ tokens : String) -> String
    {
        // TODO: write code to expand "a-c" to "abc", etc.
        if (tokens.characters.index(of: ",") != nil)
        {
            let toks = tokens.characters.split(separator: ",")
            var expanded = ""
            for tok in toks
            {
                expanded.append(Expand(String(tok)))
            }
            return expanded
        }
        
        let one = tokens.index(after: tokens.startIndex)

        // the windows version has an @ number expander
        // @ tokens are two chars. Convert them to a single char for subsequent parsing
        if (tokens.characters.count >= 2 && tokens[one] == "@")
        {
            let two = tokens.index(after: one)
            if (tokens[two] < "1" || tokens[two] > "9")
            {
                return ""  // TODO: Windows version throws
            }
        }
        
        if (tokens.characters.count == 3 && tokens[one] == "-")
        {
            var expanded = ""
            let firstInt = tokens.utf16.first!
            let lastInt = tokens.utf16.last!
            for ch in firstInt...lastInt
            {
                let temp = String(describing: UnicodeScalar(ch)!)
                expanded.append(temp)
            }
            return Expand(expanded)
        }
        
        return tokens
    }
    
    /// Does this rule override uniqueness? If not, return the default passed in from the token
    func IsUnique(_ defaultIfUnset: Bool = true) -> Bool
    {
        return _unique == nil ? defaultIfUnset : _unique!
    }
    
    /// If this rule has a letter set, does this character pass? If no letter set, all characters pass.
    func IsInSet(_ ch: Character) -> Bool
    {
        return _letterSet == nil ? true : _letterSet!.IsInSet(ch)
    }
    
    /// If this rule has a letter set, do the characters in this string pass? If no letter set, all characters pass.
    func AreAllInSet(_ str: String) -> Bool
    {
        return _letterSet == nil ? true : _letterSet!.AreAllInSet(str)
    }
    
    /// If this rule has a exhaustible letter set, reserve these letters. If no letter set, this is a no-op.
    func Reserve(_ str: String)
    {
        if (_letterSet != nil)
        {
             _letterSet!.Reserve(str)
        }
    }
    
    /// If this rule has a exhaustible letter set, return these letters. If no letter set, this is a no-op.
    func Return(_ str: String)
    {
        if (_letterSet != nil)
        {
             _letterSet!.Return(str)
        }
    }
    
    /// If this rule specifies length constraints, does this length pass? If no constraints are set, all lengths pass
    func IsValidLength(_ length: Int) -> Bool
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
    func GetMinMaxLength(_ min: inout Int, max: inout Int)
    {
        min = _minLength == nil ? 0 : _minLength!
        max = _maxLength == nil ? 1000 : _maxLength!
    }
    
    /// Checks if this claim is compliant with the rules
    func ObeysRules(_ claim: Claim, candidate : Candidate) -> Bool
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
    fileprivate func Merge(_ a: Int?, b: Int?, minimum: Bool) -> Int?
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
    fileprivate func Merge(_ a: Bool?, b: Bool?, or: Bool = true) -> Bool?
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
    fileprivate func Merge(_ a: LetterSet?, b: LetterSet?) -> LetterSet?
    {
        if (a == nil)
        {
            return b
        }
        return a
    }
    
    func Apply()
    {
        for tok in _tokenChars
        {
            let strTok = String(tok)
            // TODO: EndToken.IsWordToken
            if (DotToken.IsToken(ch: strTok) || IsDotRedefine)
            {
                DotToken.ApplyRule(strTok, rule: self)
            }
            else if (tok == "*")
            {
                StarToken.ApplyRule(rule: self)
            }
            else if (CryptoToken.IsToken(ch: strTok) || IsCryptoRedefine)
            {
                CryptoToken.ApplyRule(strTok, rule: self)
            }
            // else RepeatSequenceToken
        }
    }
}
