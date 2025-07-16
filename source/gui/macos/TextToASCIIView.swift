//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII-ART для macOS
// TextToASCIIView.swift

import SwiftUI

struct TextToASCIIView: View {
    @StateObject private var viewModel = TextToASCIIViewModel()
    @EnvironmentObject var alertManager: AlertManager
    let onBack: () -> Void
    
    var body: some View {
        ZStack {
            // Цвет фона
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Заголовок
                CustomText(text: "Конвертер текста в ASCII", size: 24, weight: .bold)
                
                // Поле ввода текста
                TextField("Введите текст (например, Hello)", text: $viewModel.inputText)
                    .font(.system(size: 16, design: .monospaced))
                    .foregroundColor(.green)
                    .padding()
                    .frame(maxWidth: .infinity) // Изменено с maxWidth: 400
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.green, lineWidth: 2)
                    )
                
                // Вывод ASCII-арта
                if !viewModel.asciiArt.isEmpty {
                    ScrollView {
                        Text(viewModel.asciiArt)
                            .font(.system(size: 8, design: .monospaced))
                            .foregroundColor(.green)
                            .padding()
                            .background(Color.black)
                            .border(Color.green.opacity(0.5), width: 1)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Изменено с maxWidth: 600, maxHeight: 400
                } else {
                    CustomText(text: "Введите текст для создания ASCII-арта", size: 14)
                        .opacity(0.6)
                        .frame(height: 400)
                }
                
                // Кнопка "Назад"
                CustomButton(title: "Вернуться в меню", action: onBack, maxWidth: .infinity, fontSize: 14) // Изменено с maxWidth: 200
            }
            .padding()
        }
        .onChange(of: viewModel.inputText) { _ in
            viewModel.convertTextToASCII()
        }
    }
}

class TextToASCIIViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var asciiArt: String = ""
    private let alertManager = AlertManager.shared
    
    func convertTextToASCII() {
        if let fontPath = Bundle.main.path(forResource: "ascii_font", ofType: "json"),
           let textCString = inputText.cString(using: .utf8) {
            if let cString = convert_text_to_ascii(fontPath, textCString) {
                asciiArt = String(cString: cString)
                free_ascii_string(cString)
            } else {
                asciiArt = ""
                alertManager.show(AlertItem(
                    title: "Ошибка",
                    message: "Не удалось преобразовать текст в ASCII.",
                    shouldExit: false
                ))
            }
        } else {
            asciiArt = ""
            alertManager.show(AlertItem(
                title: "Ошибка",
                message: "Файл шрифта не найден или текст не может быть преобразован.",
                shouldExit: false
            ))
        }
    }
}

struct TextToASCIIView_Previews: PreviewProvider {
    static var previews: some View {
        TextToASCIIView(onBack: {})
            .environmentObject(AlertManager.shared)
    }
}