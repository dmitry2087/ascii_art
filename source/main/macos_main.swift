//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// ASCII-ART app for macOS                               
// macos_main.swift

import SwiftUI
import Combine

@main
struct ASCIIArtAppMain: App {
    @StateObject private var alertManager = AlertManager.shared

    init() {
        guard #available(macOS 14.0, *) else {
            alertManager.show(
                AlertItem(
                    title: "Ошибка",
                    message: "Требуется macOS 14.0 или новее."
                )
            )
            return
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(alertManager)
                .alert(item: $alertManager.alert) { item in
                    Alert(
                        title: Text(item.title),
                        message: Text(item.message),
                        dismissButton: .default(Text("OK")) {
                            // Завершить приложение после закрытия алерта
                            NSApp.terminate(nil)
                        }
                    )
                }
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text("ASCII Art App")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

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
}


