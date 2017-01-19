
//
//  PatternError.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 10/5/16.
//  Copyright © 2016 Carine Iskander. All rights reserved.
//

import Foundation

enum PatternError: Error
{
    /// Rule must specify token character
    case ruleMustSpecifyTokenCharacter
    /// Unfinished rule
    case unfinishedRule
    /// Length rules require an integer length
    case lengthRulesRequireAnIntegerLength
    /// Mismatched braces
    case mismatchedBraces
    /// Unknown rule syntax
    case unknownRule
    /// Invalid token in anagram
    case invalidTokenInAnagram
    
    
}
