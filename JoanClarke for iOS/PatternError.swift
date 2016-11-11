
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
    /// Occurs when trying to do a claim operation on claims of different lengths
    case ClaimsOfDifferentLengths
    /// Occurs when trying to separate claims that have no overlap
    case ClaimMustBeSublaim
    /// Attempted to stake a claim that conflicts with previous stakes      
    case StakeOverlapsExistingClaim
    /// Attempted to free a claim that isn't currently staked
    case CannotFreeStake
    /// Attempted to reserve a letter that was not in the LetterSet
    case CannotReserveLetter
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
    
    
}
