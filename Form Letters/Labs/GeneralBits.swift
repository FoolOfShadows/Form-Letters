//
//  LabModel.swift
//  LabLetters
//
//  Created by Fool on 4/24/17.
//  Copyright © 2017 Fulgent Wake. All rights reserved.
//

import Cocoa

func currentDateLong() -> String {
	let formatter = DateFormatter()
	formatter.dateFormat = "MMMM d, YYYY"
	let todaysDate: String = formatter.string(from: Date())
	return todaysDate
}


extension NSView {
	//Sets most types of controllers to their off or empty state
	func clearControllers() {
		//Swift.print("main clear function activated")
		func clearChecksTextfields(theView: NSView) {
			//Swift.print("secondary clear function activated")
			for item in theView.subviews {
				switch item {
				case is NSButton: let checkbox = item as? NSButton
				checkbox?.state = .off
				case is NSTextField: let textfield = item as? NSTextField
				if (textfield?.isEditable)!{
					textfield?.textColor = NSColor.black
					textfield?.stringValue = ""
					}
				case is NSTextView: let textview = item as? NSTextView
				if (textview?.isEditable)! {
					textview?.textColor = NSColor.black
					textview?.string = ""
					}
				case is NSTabView: let tabView = item as? NSTabView
				for tabItem in (tabView?.tabViewItems)! {
					clearChecksTextfields(theView: tabItem.view!)
					}
				case is NSView: clearChecksTextfields(theView: item)
    default: continue
				}
			}
		}
		clearChecksTextfields(theView: self)
	}
	
	//If the text of an NSTextField in a view matches certain criteria its color will be set to red
	func highlightOutOfRangeResults() {
		func highlightResults(theView: NSView) {
			for item in theView.subviews {
				switch item {
				case is NSTextField:
					let textField = item as? NSTextField
					if (textField?.isEditable)! {
						if (textField?.stringValue.contains("High"))! || (textField?.stringValue.contains("Low"))! || (textField?.stringValue.contains("POSITIVE"))! || (textField?.stringValue.contains("Overactive"))! || (textField?.stringValue.contains("Underactive"))! {
							//Swift.print("Things should be turning red")
							textField?.textColor = NSColor.red
						}
					}
				case is NSView:
					highlightResults(theView: item)
				default: continue
				}
			}
		}
		highlightResults(theView: self)
	}
}

extension String {
	func findRegexMatchFrom(_ start: String, to end:String) -> String? {
		if self.contains(start) && self.contains(end) {
			guard let startRegex = try? NSRegularExpression(pattern: start, options: []) else { return nil }
			guard let endRegex = try? NSRegularExpression(pattern: end, options: []) else {return nil }
			let startMatch = startRegex.matches(in: self, options: [], range: NSRange(location: 0, length: self.characters.count))
			let endMatch = endRegex.matches(in: self, options: [], range: NSRange(location: 0, length: self.characters.count))
			
			let startRange = startMatch[0].range
			let endRange = endMatch[0].range
			
			let r = self.index(self.startIndex, offsetBy: startRange.location) ..< self.index(self.startIndex, offsetBy: endRange.location + endRange.length)
			
			return self.substring(with: r)
		} else {
			return ""
		}
	}
	
	
	func findRegexMatchBetween(_ start: String, and end: String) -> String? {
		let startStripped = start.removeRegexCharactersFromString()
		let endStripped = end.removeRegexCharactersFromString()
		if self.contains(startStripped) && self.contains(endStripped) {
			print("Starting text: \(start), Ending text: \(end)")
			guard let startRegex = try? NSRegularExpression(pattern: start, options: []) else { return nil }
			guard let endRegex = try? NSRegularExpression(pattern: end, options: []) else {return nil }
			let startMatch = startRegex.matches(in: self, options: [], range: NSRange(location: 0, length: self.characters.count))
			let endMatch = endRegex.matches(in: self, options: [], range: NSRange(location: 0, length: self.characters.count))
			
			let startRange = startMatch[0].range
			let endRange = endMatch[0].range
			
			let r = self.index(self.startIndex, offsetBy: startRange.location + startRange.length) ..< self.index(self.startIndex, offsetBy: endRange.location)
			
			return self.substring(with: r)
		} else {
			return ""
		}
		
	}
	
	
	func removeWhiteSpace() -> String {
		return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
	}
	
	func removeRegexCharactersFromString() -> String {
		let regexCharacters:Set<Character> = Set("\\*".characters)
		return String(self.characters.filter({ !regexCharacters.contains($0) }))
	}
	
	func prependSectionHeader(_ header:String) -> String {
		if !self.isEmpty {
			return "\(header.uppercased())\n\(self)"
		}
		return self
	}
	
	func prependLineHeader(_ header:String) -> String {
		if !self.isEmpty {
			return "\(header):  \(self)"
		}
		return self
	}
	
	func copyToPasteboard() {
        let myPasteboard = NSPasteboard.general
		myPasteboard.clearContents()
        myPasteboard.setString(self, forType: NSPasteboard.PasteboardType.string)
	}
}

func getDateRegEx(_ dateLine: String) -> String {
	var theMatch = ""
	let lineCount = dateLine.characters.count
	let textAsNSString = dateLine as NSString
	let theRegEx = try! NSRegularExpression(pattern: "\\d./\\d./\\d*", options: [])
	for match in theRegEx.matches(in: dateLine, options: [], range: NSMakeRange(0, lineCount)) as [NSTextCheckingResult] {
		for item in 0..<match.numberOfRanges {
			theMatch = textAsNSString.substring(with: match.range)
			//theMatch = textAsNSString.substring(with: match.range(at: item))
			let startDigit = theMatch.characters.first
			if startDigit == "0" {
				theMatch = String(theMatch.characters.dropFirst())
			}
		}
	}
	
	return theMatch
}
