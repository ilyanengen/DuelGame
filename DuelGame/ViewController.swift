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
    
    @IBAction func nextButtonDidTap(_ sender: Any) {
        guard let myViewController = self.storyboard?.instantiateController(
            withIdentifier: "GameViewController") as? GameViewController else { return }
        self.view.window?.contentViewController = myViewController
    }
}

extension ViewController: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        let isNamesFilled = playerOneNameTextField.stringValue.isEmpty == false &&
            playerTwoNameTextField.stringValue.isEmpty == false
        nextButton.isEnabled = isNamesFilled
    }
}
