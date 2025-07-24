//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII Art Studio для macOS
// TextToASCIIViewModel.swift

import Foundation
import Combine

class TextToASCIIViewModel: ObservableObject {  // Наблюдаемая модель для конвертации текста
    @Published var inputText: String = ""  // Входной текст, наблюдаемый
    @Published var asciiArt: String = ""  // Сгенерированный ASCII-арт
    private var cancellables = Set<AnyCancellable>()  // Набор подписок для Combine
    
    // Инициализатор модели
    init() {
        // Подписываемся на изменения inputText с задержкой для оптимизации
        $inputText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)  // Задержка 500 мс
            .sink { [weak self] text in  // Обработчик изменений текста
                DispatchQueue.main.async {  // Выполняем конвертацию асинхронно
                    self?.convertTextToASCII(maxWidth: self?.maxWidth ?? 120)  // Конвертируем текст
                }
            }
            .store(in: &cancellables)  // Сохраняем подписку
    }
    
    private var maxWidth: Int32 = 120  // Максимальная ширина арта
    
    // Метод для конвертации текста в ASCII-арт
    func convertTextToASCII(maxWidth: Int32 = 120) {
        self.maxWidth = max(80, min(maxWidth, 200))  // Ограничиваем ширину (80–200 символов)
        if inputText.isEmpty {  // Если входной текст пуст
            asciiArt = ""  // Очищаем результат
            return
        }
        
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
            inputText.withCString { cText in  // Преобразуем входной текст в C-строку
                if let asciiC = convert_text_to_ascii(cFontPath, cText) {  // Вызываем C-функцию конвертации
                    result = String(cString: asciiC)  // Преобразуем результат в Swift-строку
                    free_ascii_string(asciiC)  // Освобождаем память
                } else {
                    result = "Error: Conversion failed"  // Ошибка при конвертации
                }
            }
        }
        
        // Отладочный вывод для проверки результата
        print("TextToASCIIViewModel: Result = \(result.prefix(100))...")
        
        DispatchQueue.main.async {  // Обновляем UI на главном потоке
            if result.hasPrefix("Ошибка:") || result.hasPrefix("Error:") {  // Проверяем наличие ошибки
                AlertManager.shared.showAlert(title: "Ошибка", message: result)  // Показываем алерт
                self.asciiArt = ""  // Очищаем арт
            } else {
                self.asciiArt = result  // Устанавливаем результат
            }
        }
    }
}