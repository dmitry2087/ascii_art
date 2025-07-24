//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII Art Studio для macOS
// MainMenuView.swift

import SwiftUI

struct MainMenuView: View {  // Основное представление меню приложения
    @Binding var showingSettings: Bool  // Биндинг для показа настроек
    @State private var selectedMode: AppMode?  // Выбранный режим приложения
    @EnvironmentObject var alertManager: AlertManager  // Менеджер оповещений из окружения
    @EnvironmentObject var appSettings: AppSettings  // Настройки из окружения
    
    var body: some View {
        Group {  // Группа представлений для условного отображения
            if let mode = selectedMode {  // Если выбран режим
                switch mode {
                case .imageToASCII:
                    ImageToASCIIView(onBack: { selectedMode = nil })
                case .textToASCII:
                    TextToASCIIView(onBack: { selectedMode = nil })
                }
            } else {  // Иначе показываем главное меню
                MenuScreenView(
                    onImageMode: { selectedMode = .imageToASCII },
                    onTextMode: { selectedMode = .textToASCII },
                    appSettings: appSettings
                )
            }
        }
        .sheet(isPresented: $showingSettings) {  // Модальное окно настроек
            SettingsView()
                .environmentObject(appSettings)
        }
        .alert(item: $alertManager.alert) { item in  // Оповещение при ошибках
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