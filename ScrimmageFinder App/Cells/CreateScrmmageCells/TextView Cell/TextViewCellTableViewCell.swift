//
//  TextViewCellTableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 31/01/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class TextViewCellTableViewCell: MainCreateScrimmageCellTableViewCell, UITextViewDelegate {

	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var notesTextView: UITextView!
	var placeHolderString = "Please issert mesage to players"
	var placeHolder: String!
	var isDataValid = true
	
	override func configureCell(with title: String, placeHolder: String, keyboardType: UIKeyboardType?, target: UIViewController?, action: Selector?, type: CellType?) {
		self.setupCellUI()
		self.placeHolder = placeHolder
		self.label.text = "    " + title
		notesTextView.text = placeHolder
		notesTextView.textColor = UIColor.lightGray
		notesTextView.textAlignment = .center
		notesTextView.selectedTextRange = notesTextView.textRange(from: notesTextView.beginningOfDocument, to: notesTextView.beginningOfDocument)		
		notesTextView.delegate = self
	}
	
	override func clearCell() {
		self.notesTextView.text = ""
	}
	
	override func hasValidData() -> Bool {
		if notesTextView.text == nil || notesTextView.text.isEmpty || notesTextView.text == placeHolderString {
			isDataValid = false
			return false
		} else {
			isDataValid = true
			return true
		}
	}
	
	func setupCellUI() {
		if !isDataValid {
			self.notesTextView.layer.borderColor = UIColor.red.cgColor
			self.notesTextView.layer.borderWidth = 1.5
		} else {
			self.notesTextView.layer.borderColor = UIColor.lightGray.cgColor
			self.notesTextView.layer.borderWidth = 1.5
		}
		
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

		// Combine the textView text and the replacement text to
		// create the updated text string
		let currentText: String = textView.text
		let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

		// If updated text view will be empty, add the placeholder
		// and set the cursor to the beginning of the text view
		if updatedText.isEmpty {

			textView.text = self.placeHolder
			textView.textColor = UIColor.lightGray
			textView.textAlignment = .center

			textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
		}

		// Else if the text view's placeholder is showing and the
		// length of the replacement string is greater than 0, set
		// the text color to black then set its text to the
		// replacement string
		 else if textView.textColor == UIColor.lightGray && !text.isEmpty {
			textView.textColor = UIColor.white
			textView.text = text
			textView.textAlignment = .left
		}

		// For every other case, the text should change with the usual
		// behavior...
		else {
			return true
		}

		// ...otherwise return false since the updates have already
		// been made
		return false
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		returnValue?(notesTextView.text ?? "")
	}
	
	func textViewDidChangeSelection(_ textView: UITextView) {
//		if self.view.window != nil {
//			if textView.textColor == UIColor.lightGray {
//				textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
//			}
//		}
	}
}
