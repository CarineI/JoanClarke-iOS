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
            let txt = try String(contentsOfFile: path!)
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
    
}
