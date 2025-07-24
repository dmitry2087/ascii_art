//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII Art Studio для macOS
// ImageToASCIIViewModel.swift

import Foundation
import AppKit

class ImageToASCIIViewModel: ObservableObject {  // Наблюдаемая модель для обработки изображений
    @Published var asciiArt: String = ""  // Сгенерированный ASCII-арт
    
    // Метод для загрузки и конвертации изображения
    func loadImage(maxWidth: Int32 = 120, maxHeight: Int32 = 120) {
        let panel = NSOpenPanel()  // Создаем панель выбора файла
        panel.allowedContentTypes = [.png, .jpeg]  // Разрешаем только PNG и JPEG
        panel.allowsMultipleSelection = false  // Запрещаем множественный выбор
        panel.canChooseDirectories = false  // Запрещаем выбор директорий
        
        if panel.runModal() == .OK, let url = panel.url {  // Если пользователь выбрал файл
            let imagePath = url.path  // Получаем путь к файлу
            
            // Проверяем наличие файла шрифта
            guard let fontPath = Bundle.main.path(forResource: "ascii_font", ofType: "json") else {
                DispatchQueue.main.async {  // Асинхронно показываем ошибку
                    AlertManager.shared.showAlert(title: "Ошибка", message: "Файл шрифта не найден")
                    self.asciiArt = ""
                }
                return
            }
            
            var result = ""  // Переменная для результата
            fontPath.withCString { cFontPath in  // Преобразуем путь шрифта в C-строку
                imagePath.withCString { cImagePath in  // Преобразуем путь изображения
                    let safeMaxWidth = max(80, min(maxWidth, 300))  // Ограничиваем ширину
                    let safeMaxHeight = max(80, min(maxHeight, 200))  // Ограничиваем высоту
                    if let asciiC = convert_image_to_ascii(cFontPath, cImagePath, safeMaxWidth, safeMaxHeight) {  // Конвертируем
                        result = String(cString: asciiC)  // Преобразуем результат
                        free_ascii_string(asciiC)  // Освобождаем память
                    } else {
                        result = "Error: Conversion failed"  // Ошибка конвертации
                    }
                }
            }
            
            // Отладочный вывод для проверки результата
            print("ImageToASCIIViewModel: Result = \(result.prefix(100))...")
            
            DispatchQueue.main.async {  // Обновляем UI
                if result.hasPrefix("Ошибка:") || result.hasPrefix("Error:") {  // Проверяем ошибку
                    AlertManager.shared.showAlert(title: "Ошибка", message: result)
                    self.asciiArt = ""  // Очищаем арт
                } else {
                    self.asciiArt = result  // Устанавливаем результат
                }
            }
        }
    }
}