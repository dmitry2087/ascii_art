//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII Art Studio для macOS
// App.swift (главный файл приложения macOS)

import SwiftUI
import AppKit

@main
struct ASCIIArtStudioApp: App {  // Главный класс приложения, переименован для единообразия с названием "ASCII Art Studio"
    @StateObject private var alertManager = AlertManager.shared  // Менеджер оповещений, общий для всего приложения
    @StateObject private var appSettings = AppSettings()  // Настройки приложения, наблюдаемые объектом
    @State private var showingSettings = false  // Флаг для отображения окна настроек
    
    init() {  // Инициализатор приложения
        guard #available(macOS 14.0, *) else {  // Проверка версии macOS
            let alert = NSAlert()  // Создание системного оповещения
            alert.messageText = "Ошибка"
            alert.informativeText = "Требуется macOS 14.0 или новее."
            alert.alertStyle = .critical
            alert.addButton(withTitle: "OK")
            alert.runModal()
            NSApp.terminate(nil)  // Завершение приложения при несоответствии версии
            return
        }
    }
    
    var body: some Scene {  // Основная сцена приложения
        WindowGroup {  // Группа окон
            MainMenuView(showingSettings: $showingSettings)
                .environmentObject(alertManager)  // Передача менеджера оповещений в окружение
                .environmentObject(appSettings)  // Передача настроек в окружение
                .frame(minWidth: 900, minHeight: 600)  // Минимальные размеры окна
        }
        .commands {  // Команды меню
            CommandMenu("Settings") {  // Меню настроек
                Button("Open Settings") {  // Кнопка открытия настроек
                    showingSettings = true
                }
            }
        }
    }
}