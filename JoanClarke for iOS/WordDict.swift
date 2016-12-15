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
        let bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource("StubDict", ofType: "txt")
        
        do
        {
            let txt = try String(contentsOfFile: path!)
            let temp = txt.componentsSeparatedByString("\r\n")
            _wordListAlpha.appendContentsOf(temp)
            _wordListAlpha.sortInPlace()
            
            _wordListLength.appendContentsOf(temp)
            _wordListLength.sortInPlace({ s1, s2 in
                if (s1.characters.count !=  s2.characters.count)
                {
                    return s1.characters.count <  s2.characters.count
                }
               return  (s1.compare(s2) == NSComparisonResult.OrderedAscending) })
        }
        catch
        {
            
        }
        
    }
    
}