//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// ASCII-ART app for macOS   
// MainMenuView.swift

import SwiftUI

struct MainMenuView: View {
    @Binding var showingSettings: Bool
    @State private var selectedMode: AppMode?
    @EnvironmentObject var alertManager: AlertManager
    @EnvironmentObject var appSettings: AppSettings
    
    var body: some View {
        Group {
            if let mode = selectedMode {
                switch mode {
                case .imageToASCII:
                    ImageToASCIIView(onBack: { selectedMode = nil })
                case .textToASCII:
                    TextToASCIIView(onBack: { selectedMode = nil })
                }
            } else {
                MenuScreenView(
                    onImageMode: { selectedMode = .imageToASCII },
                    onTextMode: { selectedMode = .textToASCII }
                )
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
                .environmentObject(appSettings)
        }
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