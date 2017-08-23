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
    
    @IBOutlet weak var ResultsBorderButton: UIButton!
    @IBOutlet weak var EnglishBorderButton: UIButton!

    @IBOutlet weak var ResultsBottom: UITextView!
    @IBOutlet weak var EnglishBottom: UITextView!
    @IBOutlet weak var BusyIndicator: UIActivityIndicatorView!
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
        
        SearchButton.layer.cornerRadius = SearchButton.bounds.size.height / 2
        //EnglishExplanation.layer.cornerRadius = SearchButton.bounds.size.height / 4
        //SearchResults.layer.cornerRadius =  SearchButton.bounds.size.height / 4
        DotButton.layer.cornerRadius = SearchButton.bounds.size.height / 2
        StarButton.layer.cornerRadius = SearchButton.bounds.size.height / 2
        AnagramButton.layer.cornerRadius = SearchButton.bounds.size.height / 2
        CryptoOptionsControl.layer.cornerRadius = SearchButton.bounds.size.height / 8
        EnglishBorderButton.layer.cornerRadius = SearchButton.bounds.size.height / 4
        EnglishBottom.layer.cornerRadius = SearchButton.bounds.size.height / 4
        ResultsBorderButton.layer.cornerRadius = SearchButton.bounds.size.height / 4
        ResultsBottom.layer.cornerRadius = SearchButton.bounds.size.height / 4

        
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
        
        SearchResults.frame = CGRect(x: ResultsBorderButton.frame.minX,
                                     y: ResultsBorderButton.frame.minY + 30,
                                     width: ResultsBorderButton.frame.width,
                                     height:ResultsBottom.frame.maxY - 5 - (ResultsBorderButton.frame.minY + 30))
        
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
        BusyIndicator.startAnimating()
        SearchButton.tintColor = UIColor.darkGray
        SearchButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(10))
        {
            self.DoSearch()
        }
    }
    
    func DoSearch()
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
            BusyIndicator.stopAnimating()
            SearchButton.tintColor = UIColor.white
            SearchButton.isEnabled = true
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

    @IBAction func ToggleEnglishVisibile(_ sender: Any)
    {
        let gap = CGFloat(33)
        let buttonHeight = CGFloat(30)
        let buttonBottom = CGFloat(5)
        
        let bottom = SearchResults.frame.maxY
        let width = EnglishBorderButton.frame.width
        let x = EnglishBorderButton.frame.minX
        let y = EnglishBorderButton.frame.minY
        
        EnglishExplanation.isHidden = !EnglishExplanation.isHidden;
        EnglishBottom.isHidden = EnglishExplanation.isHidden
        
        if (EnglishExplanation.isHidden)
        {
            EnglishBorderButton.frame = CGRect(x: x, y: y, width: width, height: buttonHeight)
            
            let resultTop =  y + buttonHeight + gap
            let resultBottom = bottom + buttonBottom
            
            ResultsBorderButton.frame = CGRect(x: x, y: resultTop, width: width, height: bottom - resultTop - buttonBottom)
            ResultsBottom.frame = CGRect(x: x, y: resultBottom - 2 * buttonBottom, width: width, height: buttonBottom * 2)
            SearchResults.frame = CGRect(x: x, y: resultTop + buttonHeight, width: width, height: bottom - (resultTop + buttonHeight))
        }
        else
        {
            EnglishBorderButton.frame = CGRect(x: x, y: y, width: width, height: buttonHeight + buttonBottom)
        
            let resultTop =  EnglishBottom.frame.maxY + gap
            let resultBottom = bottom + buttonBottom
            
            ResultsBorderButton.frame = CGRect(x: x, y: resultTop, width: width, height: bottom - resultTop - buttonBottom)
            ResultsBottom.frame = CGRect(x: x, y: resultBottom - 2 * buttonBottom, width: width, height: buttonBottom * 2)
            SearchResults.frame = CGRect(x: x, y: resultTop + buttonHeight, width: width, height: bottom - (resultTop + buttonHeight))
        }
    }
    
    @IBAction func ToggleResultsVisible(_ sender: Any) {
        let gap = CGFloat(33)
        let buttonHeight = CGFloat(30)
        let buttonBottom = CGFloat(5)
        
        let englishTop = EnglishBorderButton.frame.minY
        let x = EnglishBorderButton.frame.minX
        let width = EnglishBorderButton.frame.width
        
        SearchResults.isHidden = !SearchResults.isHidden
        ResultsBottom.isHidden = SearchResults.isHidden

        let resultsBottom = ResultsBottom.frame.maxY  // even if it's hidden

        if (SearchResults.isHidden)  // collapsing
        {
            // Keep the bottom where it is, pull top down
            let resultHeight = buttonHeight
            ResultsBorderButton.frame = CGRect(x: x,
                                               y: resultsBottom - resultHeight,
                                               width: width,
                                               height: resultHeight)
        }
        else  // expanding results
        {
            // Keep the bottom where it is, stretch top up
            let resultHeight = SearchResults.frame.height + buttonHeight + buttonBottom;
            ResultsBorderButton.frame = CGRect(x: x,
                                               y: resultsBottom - resultHeight,
                                               width: width,
                                               height: buttonHeight * 2)
        }
        
        let englishBottom = ResultsBorderButton.frame.minY - gap

        EnglishBottom.frame = CGRect(x: x,
                                     y: englishBottom - buttonBottom * 2,
                                     width: width,
                                     height: buttonBottom * 2)
        EnglishExplanation.frame = CGRect(x: x,
                                          y: englishTop + buttonHeight,
                                          width: width,
                                          height: englishBottom - buttonBottom - (englishTop + buttonHeight))
        EnglishBorderButton.frame = CGRect(x: x,
                                          y: englishTop,
                                          width: width,
                                          height: buttonHeight * 2)
    }
}

