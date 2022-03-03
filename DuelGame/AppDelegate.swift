//
//  AppDelegate.swift
//  DuelGame
//
//  Created by Илья Билтуев on 01.03.2022.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    /*
     Игра на реакцию и точность.
     Два игрока. При старте - вводят свои имена.
     "Стреляют" по очереди.
     После вывода программой строки "к барьеру" игрок1 отсчитывает про себя X секунд и нажимает Ввод, являющийся сигналом к выстрелу.
     
     "Смертельный выстрел" должен попасть в окрестность точки t=X секунд.
     
     Количество X секунд определяется выбором части тела, в которую производится выстрел:
     сердце - 15,
     голова - 8,
     живот - 5.
     
     Размер окрестности определяется уровнем сложности и составляет:
     на сложном уровне +\- 100 мс,
     на среднем +\- 200 мс,
     на легком +\- 300 мс.
     
     Промах игрока1 передает ход игроку2.
     
     Персистенция результатов игроков в файл + 10 баллов (сохранение количества "выбитых" баллов 15/8/5 для каждого игрока и загрузка этих результатов при старте - вывод таблицы результатов)
     */

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

