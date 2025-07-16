//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII-ART для macOS                               
// App.swift (главный файл приложения macOS)

import SwiftUI
import AppKit // Для NSApplication

@main
struct ASCIIArtApp: App {
    @StateObject private var alertManager = AlertManager.shared
    
    init() {
        // Проверка совместимости версии macOS
        guard #available(macOS 14.0, *) else {
            // Показываем системный алерт
            let alert = NSAlert()
            alert.messageText = "Ошибка"
            alert.informativeText = "Требуется macOS 14.0 или новее."
            alert.alertStyle = .critical
            alert.addButton(withTitle: "OK")
            alert.runModal()
            NSApp.terminate(nil)
            return
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainMenuView()
                .environmentObject(alertManager)
                .frame(minWidth: 900, minHeight: 600)
        }
    }
}

// Менеджер алертов
final class AlertManager: ObservableObject {
    static let shared = AlertManager()
    @Published var alert: AlertItem?
    
    private init() {}
    
    func show(_ item: AlertItem) {
        alert = item
    }
}

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let shouldExit: Bool
    
    init(title: String, message: String, shouldExit: Bool = false) {
        self.title = title
        self.message = message
        self.shouldExit = shouldExit
    }
}
