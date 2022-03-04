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

enum Sound: String {
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
    private var audioQueuePlayer: AVQueuePlayer?
    
    @IBOutlet private weak var playerTurnLabel: NSTextField!
    @IBOutlet private weak var timeLabel: NSTextField!
    @IBOutlet private weak var actionResultLabel: NSTextField!
    @IBOutlet private weak var bottomInfoLabel: NSTextField!
    @IBOutlet private weak var difficultyLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.keyCode == self.enterKeyboardButtonCode {
                self.handleEnterButtonPush(timestamp: event.timestamp)
            }
            return event
        }
        
        switch difficulty {
        case .easy:
            difficultyLabel.stringValue = "Сложность: Легкая - Разброс +/- 300 мс"
        case .normal:
            difficultyLabel.stringValue = "Сложность: Средняя - Разброс +/- 200 мс"
        case .hard:
            difficultyLabel.stringValue = "Сложность: Тяжелая - Разброс +/- 100 мс"
        case .none:
            break
        }
    }
    
    private func handleEnterButtonPush(timestamp: TimeInterval) {
        if isGameInProgress == true {
            print("SHOOT!")
            elapsedTime = timestamp - previousTimeInterval
            handleHit()
            updateUI()
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
    
    private func handleHit() {
        
        // Вычисляем: Попадание ИЛИ Промах
        let accuracy = difficulty.rawValue

        let heartRange = (Shot.heart.rawValue.milliseconds - accuracy)...(Shot.heart.rawValue.milliseconds + accuracy)
        let headRange = (Shot.head.rawValue.milliseconds - accuracy)...(Shot.head.rawValue.milliseconds + accuracy)
        let bodyRange = (Shot.body.rawValue.milliseconds - accuracy)...(Shot.body.rawValue.milliseconds + accuracy)
        
        let possibleShotRanges = [Shot.heart: heartRange, Shot.head: headRange, Shot.body: bodyRange]
        
        var shotBodyPart: Shot?
        
        for range in possibleShotRanges {
            if range.value.contains(elapsedTime.milliseconds) {
                shotBodyPart = range.key
                break
            }
        }
        
        // Обработка промаха
        guard let shotBodyPart = shotBodyPart else {
            actionResultLabel.stringValue = "Промах"
            playSounds([.bang, .miss])
            return
        }
        
        // Обработка попадания
        playSounds([.bang, .cry])
        
        addScoreToCurrentPlayer(shot: shotBodyPart)
        
        switch shotBodyPart {
        case .heart:
            actionResultLabel.stringValue = "Сердце"
        case .head:
            actionResultLabel.stringValue = "Голова"
        case .body:
            actionResultLabel.stringValue = "Туловище"
        }
    }
    
    private func playSounds(_ sounds: [Sound]) {
        var audioItems: [AVPlayerItem] = []
        for sound in sounds {
            let url = URL(fileURLWithPath: Bundle.main.path(forResource: sound.rawValue, ofType: "wav")!)
            let item = AVPlayerItem(url: url)
            audioItems.append(item)
        }
        audioQueuePlayer = AVQueuePlayer(items: audioItems)
        audioQueuePlayer?.play()
    }

    private func resetUI() {
        switch playerTurn {
        case .none:
            playerTurnLabel.stringValue = ""
        case .playerOne:
            playerTurnLabel.stringValue = "Ход Игрока 1: \(playerOneName)"
        case .playerTwo:
            playerTurnLabel.stringValue = "Ход Игрока 2: \(playerTwoName)"
        }
        timeLabel.stringValue = ""
        actionResultLabel.stringValue = "Целится"
        bottomInfoLabel.stringValue = "Нажмите Enter чтобы выстрелить"
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
        bottomInfoLabel.stringValue = "Нажмите Enter чтобы начать ход"
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
