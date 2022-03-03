//
//  GameViewController.swift
//  DuelGame
//
//  Created by Илья Билтуев on 03.03.2022.
//

import Cocoa
import AppKit

class GameViewController: NSViewController {

    private let enterKeyboardButtonCode: UInt16 = 36
    
    @IBOutlet private weak var playerTurnLabel: NSTextField!
    
    @IBOutlet private weak var timeLabel: NSTextField!
    
    @IBOutlet private weak var actionResultLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.keyCode == self.enterKeyboardButtonCode {
                print("Enter button was pressed")
            }
            return event
        }
    }
}
