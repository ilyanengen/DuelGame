//
//  GameViewController.swift
//  DuelGame
//
//  Created by Илья Билтуев on 03.03.2022.
//

import Cocoa
import AppKit
import AVFoundation

enum Turn {
    case playerOne
    case playerTwo
    case none
}

enum Sound {
    case bang
    case cry
    case miss
}

//Размер окрестности определяется уровнем сложности и составляет в мс:
enum Difficulty: TimeInterval {
    case easy = 300
    case normal = 200
    case hard = 100
}

class GameViewController: NSViewController {
    
    var playerOneName = ""
    var playerTwoName = ""
    var difficulty: Difficulty! // TODO: Add UI for difficulty selection

    private var isGameInProgress: Bool = false
    
    private var playerTurn: Turn = .none
    
    private let enterKeyboardButtonCode: UInt16 = 36
    
    private var previousTimeInterval: TimeInterval = 0
    
    private var elapsedTime: TimeInterval = 0
    
    @IBOutlet private weak var playerTurnLabel: NSTextField!
    
    @IBOutlet private weak var timeLabel: NSTextField!
    
    @IBOutlet private weak var actionResultLabel: NSTextField!
    
    private var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.keyCode == self.enterKeyboardButtonCode {
                print("Enter button was pressed")
                self.handleEnterButtonPush(timestamp: event.timestamp)
            }
            return event
        }
    }
    
    private func handleEnterButtonPush(timestamp: TimeInterval) {
        if isGameInProgress == true {
            print("SHOOT!")
            elapsedTime = timestamp - previousTimeInterval
            updateUI()
            playSound(.bang)
            isGameInProgress = false
        } else {
            print("START GAME!")
            setPlayerTurn()
            resetUI()
            isGameInProgress = true
            previousTimeInterval = timestamp
            elapsedTime = 0
        }
    }
    
    private func setPlayerTurn() {
        switch playerTurn {
        case .none:
            playerTurn = .playerOne
        case .playerOne:
            playerTurn = .playerTwo
        case .playerTwo:
            playerTurn = .playerOne
        }
    }
    
    private func playSound(_ sound: Sound) {
        var name: String
        var ext: String
        switch sound {
        case .bang:
            name = "bang"
            ext = "ogg"
        case .cry:
            name = "cry"
            ext = "wav"
        case .miss:
            name = "miss"
            ext = "wav"
        }
        guard let asset = NSDataAsset(name: name) else { return }
        do {
            audioPlayer = try AVAudioPlayer(data: asset.data, fileTypeHint: ext)
            audioPlayer?.play()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    private func resetUI() {
        switch playerTurn {
        case .none:
            playerTurnLabel.stringValue = "Get ready!"
        case .playerOne:
            playerTurnLabel.stringValue = playerOneName
        case .playerTwo:
            playerTurnLabel.stringValue = playerTwoName
        }
        timeLabel.stringValue = ""
        actionResultLabel.stringValue = ""
    }
    
    private func updateUI() {
        let elapsedTimeInMilliseconds = Int((elapsedTime * 1000).rounded())
        // Возвращает частное и остаток от этого значения, деленные на заданное значение.
        let (minutes, remainderInMilliseconds) = elapsedTimeInMilliseconds.quotientAndRemainder(dividingBy: 60 * 1000)
        let (seconds, milliseconds) = remainderInMilliseconds.quotientAndRemainder(dividingBy: 1000)

        let minutesLabelString = String(minutes)
        let secondsLabelString = String(format: "%02d", seconds)
        let millisecondsLabelString = String(format: "%02d", milliseconds)

        timeLabel.stringValue = "\(minutesLabelString):\(secondsLabelString):\(millisecondsLabelString)"
        
        
        // TODO: Calculate MISS OR HIT
        
        // TODO: Add difficulties EASY / NORMAL / HARD
        
        
        actionResultLabel.stringValue = "MISS / HIT"
    }
}
