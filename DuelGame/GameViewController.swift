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
enum Difficulty: Int {
    case easy = 300
    case normal = 200
    case hard = 100
}

// Количество X секунд определяется выбором части тела, в которую производится выстрел:
enum Shot: TimeInterval {
    case heart = 15
    case head = 8
    case body = 5
}

class GameViewController: NSViewController {
    
    var playerOneName = ""
    var playerTwoName = ""
    var difficulty: Difficulty! // TODO: Add UI for difficulty selection
    
    private var playerOneScore: [Int] = []
    private var playerTwoScore: [Int] = []
    
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
            playerTurnLabel.stringValue = ""
        case .playerOne:
            playerTurnLabel.stringValue = playerOneName
        case .playerTwo:
            playerTurnLabel.stringValue = playerTwoName
        }
        timeLabel.stringValue = ""
        actionResultLabel.stringValue = "К барьеру!"
    }
    
    private func updateUI() {
        let elapsedTimeInMilliseconds = elapsedTime.milliseconds
        // Возвращает частное и остаток от этого значения, деленные на заданное значение.
        let (minutes, remainderInMilliseconds) = elapsedTimeInMilliseconds.quotientAndRemainder(dividingBy: 60 * 1000)
        let (seconds, milliseconds) = remainderInMilliseconds.quotientAndRemainder(dividingBy: 1000)

        let minutesLabelString = String(minutes)
        let secondsLabelString = String(format: "%02d", seconds)
        let millisecondsLabelString = String(format: "%02d", milliseconds)

        timeLabel.stringValue = "\(minutesLabelString):\(secondsLabelString):\(millisecondsLabelString)"
        
        
        // TODO: Calculate MISS OR HIT
        
        let accuracy = difficulty.rawValue
        
        let heartRange = (Shot.heart.rawValue.milliseconds - accuracy)...(Shot.heart.rawValue.milliseconds + accuracy)
        let headRange = (Shot.head.rawValue.milliseconds - accuracy)...(Shot.head.rawValue.milliseconds + accuracy)
        let bodyRange = (Shot.body.rawValue.milliseconds - accuracy)...(Shot.body.rawValue.milliseconds + accuracy)
        
        let possibleShotRanges = [Shot.heart: heartRange, Shot.head: headRange, Shot.body: bodyRange]
        
        var shotBodyPart: Shot?
        
        for range in possibleShotRanges {
            if range.value.contains(elapsedTimeInMilliseconds) {
                shotBodyPart = range.key
                break
            }
        }
        
        guard let shotBodyPart = shotBodyPart else {
            actionResultLabel.stringValue = "MISS"
            playSound(.miss)
            return
        }
        
        addScoreToCurrentPlayer(shot: shotBodyPart)
        
        switch shotBodyPart {
        case .heart:
            actionResultLabel.stringValue = "HIT HEART"
        case .head:
            actionResultLabel.stringValue = "HIT HEAD"
        case .body:
            actionResultLabel.stringValue = "HIT BODY"
        }
    }
    
    private func addScoreToCurrentPlayer(shot: Shot) {
        switch playerTurn {
        case .playerOne:
            playerOneScore.append(Int(shot.rawValue))
        case .playerTwo:
            playerTwoScore.append(Int(shot.rawValue))
        case .none:
            break
        }
    }
}

extension TimeInterval {
    var milliseconds: Int {
        return Int((self * 1000).rounded())
    }
}
