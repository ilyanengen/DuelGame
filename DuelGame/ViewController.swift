//
//  ViewController.swift
//  DuelGame
//
//  Created by Илья Билтуев on 01.03.2022.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet private weak var nextButton: NSButton!
    
    @IBOutlet private weak var playerOneNameTextField: NSTextField!
    
    @IBOutlet private weak var playerTwoNameTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playerOneNameTextField.delegate = self
        playerTwoNameTextField.delegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction private func nextButtonDidTap(_ sender: Any) {
        print("NEXT BUTTON TAP")
    }
}

extension ViewController: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        let isNamesFilled = playerOneNameTextField.stringValue.isEmpty == false &&
            playerTwoNameTextField.stringValue.isEmpty == false
        nextButton.isEnabled = isNamesFilled
    }
}
