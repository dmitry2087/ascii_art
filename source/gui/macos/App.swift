//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// ASCII-ART app for macOS                               
// App.swift

import SwiftUI

@main
struct ASCIIArtApp: App {
    @StateObject private var alertManager = AlertManager.shared
    
    init() {
        // Проверка совместимости версии macOS
        guard #available(macOS 14.0, *) else {
            alertManager.show(
                AlertItem(
                    title: "Ошибка",
                    message: "Требуется macOS 14.0 или новее."
                )
            )
            return
        }
        
        // Установка иконки приложения
        if let iconPath = Bundle.main.path(forResource: "icon", ofType: "png") {
            let iconImage = NSImage(contentsOfFile: iconPath)
            NSApp.applicationIconImage = iconImage
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainMenuView()
                .environmentObject(alertManager)
                .frame(minWidth: 900, minHeight: 600)
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified)
        .alert(item: $alertManager.alert) { item in
            Alert(
                title: Text(item.title),
                message: Text(item.message),
                dismissButton: .default(Text("OK")) {
                    if item.shouldExit {
                        NSApp.terminate(nil)
                    }
                }
            )
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
