//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII-ART для macOS                               
// App.swift (главный файл приложения macOS)

import SwiftUI
import AppKit

@main
struct ASCIIArtApp: App {
    @StateObject private var alertManager = AlertManager.shared
    @StateObject private var appSettings = AppSettings()
    @State private var showingSettings = false
    
    init() {
        guard #available(macOS 14.0, *) else {
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
            MainMenuView(showingSettings: $showingSettings)
                .environmentObject(alertManager)
                .environmentObject(appSettings)
                .frame(minWidth: 900, minHeight: 600)
        }
        .commands {
            CommandMenu("Settings") {
                Button("Open Settings") {
                    showingSettings = true
                }
            }
        }
    }
}