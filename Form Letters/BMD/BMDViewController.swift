//
//  BMDViewController.swift
//  Form Letters
//
//  Created by Fool on 11/15/18.
//  Copyright © 2018 Fool. All rights reserved.
//

import Cocoa

class BMDViewController: NSViewController {
    @IBOutlet weak var ptNameView: NSTextField!
    @IBOutlet weak var currentDateView: NSTextField!
    @IBOutlet weak var testDateView: NSTextField!
    @IBOutlet weak var tScoreView: NSTextField!
    @IBOutlet weak var locationView: NSTextField!
    @IBOutlet weak var dxView: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        currentDateView.stringValue = currentDateLong()
    }
    
    @IBAction func clearBMD(_ sender: Any) {
    }
    
    @IBAction func processBMD(_ sender: Any) {
        let currentBMD = BMDData(ptName:ptNameView.stringValue, ltrDate:currentDateView.stringValue, testDate:testDateView.stringValue, tScore:tScoreView.doubleValue, location:locationView.stringValue)
        
        //Pass the final letter string to the clipboard
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString(currentBMD.generateOutput(), forType: NSPasteboard.PasteboardType.string)
        
        dismiss(self)
        
    }
    
}
