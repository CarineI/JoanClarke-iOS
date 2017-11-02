//
//  WordDict.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 12/14/16.
//  Copyright © 2016 Carine Iskander. All rights reserved.
//

import Foundation

class WordDict
{
    var _wordListAlpha: [Word]
    var _wordListLength : [Word]
 
    init()
    {
        _wordListAlpha = []
        _wordListLength = []
    }
    
    func LoadFromBundle(full : Bool)
    {
        let bundle = Bundle.main
        let pathFull = full ? bundle.path(forResource: "FullDictionary", ofType: "txt")
            : bundle.path(forResource: "StubDict", ofType: "txt")
        
        let pathLenSort = bundle.path(forResource: "LengthSortedFullDictionary", ofType: "txt")

        do
        {
            let txtFull = try String(contentsOfFile: pathFull!).uppercased()
            let tempFull = txtFull.components(separatedBy: "\r\n")
            
            //_wordListAlpha.append(contentsOf: tempFull)
            _wordListAlpha.reserveCapacity(tempFull.count)
            for temp in tempFull
            {
                if (temp.characters.count > 0)
                {
                    let w = Word(str: temp)
                    _wordListAlpha.append(w)
                }
            }
            
            let txtLenSort = try String(contentsOfFile: pathLenSort!).uppercased()
            let tempLenSort = txtLenSort.components(separatedBy: "\r\n")

            //_wordListLength.append(contentsOf: tempLenSort)
            _wordListLength.reserveCapacity(tempLenSort.count)
            for temp in tempLenSort
            {
                if (temp.characters.count > 0)
                {
                    _wordListLength.append(Word(str: temp))
                }
            }
        }
        catch
        {
            
        }
        
    }
    
    func DoSearch(pattern : Pattern, rules: [Rule]) -> [String]
    {
        Rule.ApplyAllRules(rules: rules)
        
        var first = _wordListAlpha.startIndex
        var last = _wordListAlpha.endIndex
     
        let prefix = "" // TODO: pattern.GetPrefix()
        var minLength = 0
        var maxLength = 0
        pattern.WordLengthOfMatches(minLength: &minLength, maxLength: &maxLength)

        var dictionary = _wordListAlpha
        if (prefix.characters.count > 0)
        {
            if (minLength > 0 && maxLength == minLength)
            {
                dictionary = _wordListLength
                FindLengthSubset(minLength: minLength, maxLength: maxLength, prefix: prefix, first: &first, last: &last)
            }
            else
            {
                FindAlphaSubset(prefix: prefix, first: &first, last: &last)
            }
        }
        else if (minLength > 1 || maxLength < LongestWordLength())
        {
            dictionary = _wordListLength
            FindLengthSubset(minLength: minLength, maxLength: maxLength, prefix: "", first: &first, last: &last)
        }
        
        var results : [String]
        results = []
        do
        {
            for i in first..<last
            {
                let word = dictionary[i]
                if (try pattern.Match(word: word))
                {
                    results.append(word.Original)
                }
            }
        }
        catch PatternError.unrecognizedToken(let token)
        {
            results.append(token)
        }
        catch
        {
            results.append("Error")
        }

        
        return results
    }
    
    private func LongestWordLength() -> Int
    {
        return _wordListLength[_wordListLength.count - 1].Normalized.characters.count
    }
    
    /// Find either the index of the first word that matches the prefix,
    /// or (if after == true), the first word after any matches
    private func BinarySearch(dictionary: [Word], prefix: String, firstIndex: Int, lastIndex: Int, after: Bool) -> Int
    {
        var first = firstIndex
        var last = lastIndex
        if (first == -1)
        {
            first = 0
            last = dictionary.count
        }
        
        while (first < last)
        {
            let mid = (first + last) / 2
            var word = dictionary[mid].Normalized
            if (word.characters.count > prefix.characters.count)
            {
                word = word.substring(to: prefix.endIndex)
            }
            let comp = word.compare(prefix)
            if (comp == ComparisonResult.orderedAscending)
            {
                first = mid + 1
            }
            else if (comp == ComparisonResult.orderedDescending)
            {
                last = mid - 1
            }
            else if (after)
            {
                first = mid + 1
            }
            else
            {
                last = mid
            }
        }
        
        return first
    }

    /// Find either the index of the first word that matches the length,
    /// or (if after == true), the first word that is too long
    private func BinarySearch(minLength: Int, maxLength: Int, after: Bool) -> Int
    {
        var first = 0
        var last = _wordListLength.count
        
        while (first < last)
        {
            let mid = (first + last) / 2
            let length = _wordListLength[mid].Normalized.characters.count
            if (length < minLength)
            {
                // this word is shorter than we want
                first = mid + 1
            }
            else if (length > maxLength)
            {
                // this word is longer than we want (it could still be a candidate for after)
                last = after ? mid : (mid - 1)
            }
            else if (after)
            {
                // the word is the right length, but we're trying to find the first word that isn't
                first = mid + 1
            }
            else
            {
                // the word is the right length, but we're trying to find the first such word
                last = mid
            }
        }
        
        return first
    }
    
    /// Binary search for prefix within the alphabetic list, where...
    /// first == first word that starts with prefix, or index where one would occur if none
    /// last == first word that doesn't, or same as first if none
    private func FindAlphaSubset(prefix: String, first: inout Int, last: inout Int)
    {
        first = BinarySearch(dictionary: _wordListAlpha, prefix: prefix, firstIndex: -1, lastIndex: -1, after: false)
        last = BinarySearch(dictionary: _wordListAlpha, prefix: prefix, firstIndex: -1, lastIndex: -1, after: true)
    }
    
    /// Binary search for prefix within the alphabetic list, where...
    /// first == first word that starts with prefix, or index where one would occur if none
    /// last == first word that doesn't, or same as first if none
    private func FindLengthSubset(minLength: Int, maxLength: Int, prefix: String, first: inout Int, last: inout Int)
    {
        first = BinarySearch(minLength: minLength, maxLength: maxLength, after: false)
        last = BinarySearch(minLength: minLength, maxLength: maxLength, after: true)
        
        if (prefix.characters.count > 0 && minLength == maxLength)
        {
            // The length-sorted array is alphabetically sorted within each length group
            // So if we have a prefix, we can apply it here to further reduce the subset
            first = BinarySearch(dictionary: _wordListLength, prefix: prefix, firstIndex: -1, lastIndex: -1, after: false)
            last = BinarySearch(dictionary: _wordListLength, prefix: prefix, firstIndex: -1, lastIndex: -1, after: true)
        }
    }
}
