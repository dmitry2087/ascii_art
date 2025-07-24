//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII Art Studio для macOS
// AlertManager.swift

import SwiftUI

struct AlertItem: Identifiable {  // Структура элемента оповещения
    let id = UUID()  // Уникальный идентификатор
    let title: String  // Заголовок
    let message: String  // Сообщение
    let shouldExit: Bool  // Флаг завершения приложения
}

class AlertManager: ObservableObject {  // Менеджер оповещений, наблюдаемый
    static let shared = AlertManager()  // Синглтон
    
    @Published var alert: AlertItem?  // Текущее оповещение
    
    private init() {}  // Приватный инициализатор
    
    func showAlert(title: String, message: String, shouldExit: Bool = false) {  // Показ оповещения
        alert = AlertItem(title: title, message: message, shouldExit: shouldExit)
    }
}