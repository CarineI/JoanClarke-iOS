//
//  ViewController.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 8/17/16.
//  Copyright © 2016 Carine Iskander. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    var dict : WordDict?
    
    @IBOutlet weak var SearchField: UISearchBar!
    @IBOutlet weak var CryptoOptionsControl: UISegmentedControl!
    @IBOutlet weak var AnagramButton: UIButton!
    @IBOutlet weak var StarButton: UIButton!
    @IBOutlet weak var DotButton: UIButton!
    @IBOutlet weak var SearchResults: UITextView!
    @IBOutlet weak var EnglishExplanation: UITextView!
    @IBOutlet weak var InputField: UITextField!
    @IBOutlet weak var SearchButton: UIButton!
    @IBOutlet weak var HelpLinkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("We have some clue what we're doing")
        
        SearchButton.layer.cornerRadius = SearchButton.bounds.size.width / 2
        EnglishExplanation.layer.cornerRadius = SearchButton.bounds.size.width / 4
        SearchResults.layer.cornerRadius =  SearchButton.bounds.size.width / 4
        DotButton.layer.cornerRadius = SearchButton.bounds.size.width / 2
        StarButton.layer.cornerRadius = SearchButton.bounds.size.width / 2
        AnagramButton.layer.cornerRadius = SearchButton.bounds.size.width / 2
        CryptoOptionsControl.layer.cornerRadius = SearchButton.bounds.size.width / 8
        
        InputField.becomeFirstResponder()

        InputField.autocorrectionType = .no
        InputField.autocapitalizationType = .none
        
        dict = WordDict()
        dict!.LoadFromBundle(full: true)
        
        let attrStr = try! NSAttributedString(
            data: "<span style='color:white; text-decoration:underline' href='http://joanclarke.info'>www.joanclarke.info</span>".data(
                using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        HelpLinkButton.setAttributedTitle(attrStr, for: UIControlState.normal)
        
    }
   
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
       do
       {
            let trimmed = InputField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
            let pattern = try Pattern(raw: trimmed)
            EnglishExplanation.text = pattern.ExplainInEnglish()
        }
       catch PatternError.unrecognizedToken(let token)
       {
            SearchResults.text = token + " not recognized"
            SearchResults.textColor = UIColor.red
       }
       catch
       {
            SearchResults.text = "Unknown exception"
            SearchResults.textColor = UIColor.red
        }
    }
    
    // Return key
    @IBAction func PrimaryAction(_ sender: Any)
    {
        SearchClicked(sender)
    }
    
    @IBAction func SearchClicked(_ sender: Any)
    {
        do{
            let trimmed = InputField.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
            let pattern =  try Pattern(raw: trimmed)
            let searchResults = dict!.DoSearch(pattern: pattern)
            var text  = ""
            for result in searchResults
            {
                text.append(result)
                text.append("\n")
            }
            
            SearchResults.text = text
            SearchResults.textColor = UIColor.black
            SearchResults.flashScrollIndicators()
        }
        catch PatternError.unrecognizedToken(let token)
        {
            SearchResults.text = token + " not recognized"
            SearchResults.textColor = UIColor.red
        }
        catch
        {
            SearchResults.text = "Unknown exception"
            SearchResults.textColor = UIColor.red
        }
    }
    
    @IBAction func OnDotButton(_ sender: Any)
    {
        InputField.insertText(".")
    }

    @IBAction func OnStarButton(_ sender: Any)
    {
        InputField.insertText("*")
    }

    @IBAction func OnAnagramButton(_ sender: Any) 
    {
        
        InputField.insertText("<>")
        if let selRange = InputField.selectedTextRange
        {
            if let newPos = InputField.position(from: selRange.start, offset: -1)
            {
                InputField.selectedTextRange = InputField.textRange(from: newPos, to: newPos)
            }
        }
    }

    
    @IBAction func OnCryptoOptionAction(_ sender: Any)
    {
        InputField.insertText(String(CryptoOptionsControl.selectedSegmentIndex))
        CryptoOptionsControl.selectedSegmentIndex = -1
    }
    
    @IBAction func helpTouchUpInside(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string:"http://joanclarke.info")! as URL)
    }

}

