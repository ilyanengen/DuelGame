//
//  GameViewController.swift
//  DuelGame
//
//  Created by Илья Билтуев on 03.03.2022.
//

import Cocoa

class GameViewController: NSViewController {

    @IBOutlet private weak var playerTurnLabel: NSTextField!
    
    @IBOutlet private weak var timeLabel: NSTextField!
    
    @IBOutlet private weak var actionResultLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
}
