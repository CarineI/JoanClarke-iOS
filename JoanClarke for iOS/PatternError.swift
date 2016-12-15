
//
//  PatternError.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 10/5/16.
//  Copyright © 2016 Carine Iskander. All rights reserved.
//

import Foundation

enum PatternError: ErrorType
{
    /// Rule must specify token character
    case RuleMustSpecifyTokenCharacter
    /// Unfinished rule
    case UnfinishedRule
    /// Length rules require an integer length
    case LengthRulesRequireAnIntegerLength
    /// Mismatched braces
    case MismatchedBraces
    /// Unknown rule syntax
    case UnknownRule
    /// Invalid token in anagram
    case InvalidTokenInAnagram
    
    
}
