//
//  ViewController.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 8/17/16.
//  Copyright © 2016 Carine Iskander. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var dict : WordDict?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("We have no clue what we're doing")
        
        SearchButton.layer.cornerRadius = SearchButton.bounds.size.width / 2
        
        EnglishExplanation.layer.cornerRadius = SearchButton.bounds.size.width / 4
        
        SearchResults.layer.cornerRadius =  SearchButton.bounds.size.width / 4
        
    InputField.becomeFirstResponder()
    
     InputField.autocorrectionType = .no
    InputField.autocapitalizationType = .none
        
        dict = WordDict()
        dict!.LoadFromBundle()
    }

    @IBOutlet weak var SearchResults: UITextView!
    @IBOutlet weak var EnglishExplanation: UITextView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBOutlet weak var InputField: UITextField!

   @IBOutlet weak var SearchButton: UIButton!
    
    @IBAction func TouchInButton(_ sender: Any) {
          SearchButton.setTitleColor( UIColor.red, for: UIControlState.normal)
    }
    
    @IBAction func TouchInInputField(_ sender: Any) {
        
        InputField.becomeFirstResponder()
    }
    
    // Lose focus
    @IBAction func EditingDidEnd(_ sender: Any) {
        InputField.resignFirstResponder()
}
 
    // InputField changed
    @IBAction func EditingChanged(_ sender: Any) {
       SearchResults.text = InputField.text!
    }
    
    // Return key
    @IBAction func PrimaryAction(_ sender: Any) {
    }
    @IBAction func SearchClicked(_ sender: Any)
    {
        do{
            let pattern =  try Pattern(raw: InputField.text!)
            let searchResults = dict!.DoSearch(pattern: pattern)
            var text  = ""
            for result in searchResults
            {
                text.append(result)
                text.append("\n")
            }
            
            SearchResults.text = text
        }
        catch {}
    }
    
}

