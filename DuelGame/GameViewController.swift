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
    
    private var previousTimeInterval: TimeInterval = 0
    
    private var elapsedTime: TimeInterval = 0
    
    @IBOutlet private weak var playerTurnLabel: NSTextField!
    
    @IBOutlet private weak var timeLabel: NSTextField!
    
    @IBOutlet private weak var actionResultLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.keyCode == self.enterKeyboardButtonCode {
                print("Enter button was pressed")
                self.handleTime(timestamp: event.timestamp)
                self.updateUI()
            }
            return event
        }
    }
    
    private func handleTime(timestamp: TimeInterval) {
        elapsedTime = timestamp - previousTimeInterval
        previousTimeInterval = timestamp
    }
    
    private func updateUI() {
        let totalElapsed = elapsedTime

        let hundredths = Int((totalElapsed * 100).rounded())
        let (minutes, hundredthsOfSeconds) = hundredths.quotientAndRemainder(dividingBy: 60 * 100)
        let (seconds, milliseconds) = hundredthsOfSeconds.quotientAndRemainder(dividingBy: 100)

        let minutesLabelString = String(minutes)
        print("minutesLabelString: \(minutesLabelString)")
        let secondsLabelString = String(format: "%02d", seconds)
        print("secondsLabelString: \(secondsLabelString)")
        let milliSecondsString = String(format: "%02d", milliseconds)
        print("milliSecondsString: \(milliSecondsString)")
    }
}
