//
//  ViewController.swift
//  JoanClarke for iOS
//
//  Created by Carine Iskander on 8/17/16.
//  Copyright © 2016 Carine Iskander. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("We have no clue what we're doing")
        /*let r = CGRect(x: 0, y: 0, width: SearchButton.frame.minX - InputField.frame.minX - 15, height: InputField.frame.height)
        InputField.frame = r
        InputField.setNeedsDisplay()*/
        
        SampleText.text = "Hello World"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var SampleText: UITextView!


   @IBOutlet weak var SearchButton: UIButton!
    
    @IBAction func TouchInButton(_ sender: Any) {
          SearchButton.setTitleColor( UIColor.red, for: UIControlState.normal)
    }

   /* @IBAction func OnEditingBegin(sender: AnyObject)
    {
        SearchButton.enabled = true //UIControlState.Normal
    }*/
}

