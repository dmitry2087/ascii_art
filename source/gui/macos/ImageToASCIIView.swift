//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII-ART для macOS
// ImageToASCIIView.swift

import SwiftUI
import AppKit // Для NSOpenPanel

struct ImageToASCIIView: View {
    @StateObject private var viewModel = ImageToASCIIViewModel()
    @EnvironmentObject var alertManager: AlertManager
    let onBack: () -> Void
    
    var body: some View {
        ZStack {
            // Цвет фона
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Заголовок
                CustomText(text: "Конвертер изображений в ASCII", size: 24, weight: .bold)
                
                // Кнопка выбора изображения
                CustomButton(title: "Выбрать изображение (PNG/JPG)", action: {
                    viewModel.loadImage()
                }, maxWidth: .infinity) // Изменено с maxWidth: 300
                
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
                    CustomText(text: "Изображение не выбрано", size: 14)
                        .opacity(0.6)
                        .frame(height: 400)
                }
                
                // Кнопка "Назад"
                CustomButton(title: "Вернуться в меню", action: onBack, maxWidth: .infinity, fontSize: 14) // Изменено с maxWidth: 200
            }
            .padding()
        }
    }
}

class ImageToASCIIViewModel: ObservableObject {
    @Published var asciiArt: String = ""
    private let alertManager = AlertManager.shared
    
    func loadImage() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.png, .jpeg]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        
        if panel.runModal() == .OK, let url = panel.url {
            if let fontPath = Bundle.main.path(forResource: "ascii_font", ofType: "json") {
                if let cString = convert_image_to_ascii(fontPath, url.path, 100) {
                    asciiArt = String(cString: cString)
                    free_ascii_string(cString)
                } else {
                    alertManager.show(AlertItem(
                        title: "Ошибка",
                        message: "Не удалось преобразовать изображение в ASCII.",
                        shouldExit: false
                    ))
                }
            } else {
                alertManager.show(AlertItem(
                    title: "Ошибка",
                    message: "Файл шрифта не найден.",
                    shouldExit: true
                ))
            }
        }
    }
}

struct ImageToASCIIView_Previews: PreviewProvider {
    static var previews: some View {
        ImageToASCIIView(onBack: {})
            .environmentObject(AlertManager.shared)
    }
}