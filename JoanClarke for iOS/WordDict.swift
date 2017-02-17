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
    var _wordListAlpha: [String]
    var _wordListLength : [String]
    
    init()
    {
        _wordListAlpha = []
        _wordListLength = []
    }
    
    func LoadFromBundle()
    {
        let bundle = Bundle.main
        let path = bundle.path(forResource: "StubDict", ofType: "txt")
        
        do
        {
            let txt = try String(contentsOfFile: path!).uppercased()
            let temp = txt.components(separatedBy: "\r\n")
            _wordListAlpha.append(contentsOf: temp)
            _wordListAlpha.sort()
            
            _wordListLength.append(contentsOf: temp)
            _wordListLength.sort(by: { s1, s2 in
                if (s1.characters.count !=  s2.characters.count)
                {
                    return s1.characters.count <  s2.characters.count
                }
               return  (s1.compare(s2) == ComparisonResult.orderedAscending) })
        }
        catch
        {
            
        }
        
    }
    
    func DoSearch(pattern : Pattern) -> [String]
    {
        var results : [String]
        results = []
        let first = _wordListAlpha.startIndex
        let last = _wordListAlpha.endIndex
        
        do
        {
            for i in first..<last
            {
                let word = _wordListAlpha[i]
                if (try pattern.Match(word: word))
                {
                    results.append(_wordListAlpha[i])
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
}
