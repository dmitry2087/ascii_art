//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII Art Studio для macOS
// ImageToASCIIView.swift

import SwiftUI
import AppKit

struct ImageToASCIIView: View {
    @StateObject private var viewModel = ImageToASCIIViewModel()  // Модель для обработки изображений
    @EnvironmentObject var alertManager: AlertManager  // Менеджер оповещений
    @EnvironmentObject var appSettings: AppSettings  // Настройки приложения
    let onBack: () -> Void  // Колбэк для возврата
    @State private var maxWidth: Int32 = 120  // Максимальная ширина ASCII-арта
    @State private var maxHeight: Int32 = 120  // Максимальная высота ASCII-арта
    
    var body: some View {
        GeometryReader { geometry in  // Адаптация под размер окна
            ZStack {  // Фон и контент
                Color.black.ignoresSafeArea(.all)  // Черный фон на весь экран
                
                VStack(spacing: 20) {  // Вертикальный стек элементов
                    CustomText(text: "Конвертер изображений в ASCII", size: 24, weight: .bold)  // Заголовок
                    
                    CustomButton(title: "Выбрать изображение (PNG/JPG)", action: {  // Кнопка выбора файла
                        viewModel.loadImage(maxWidth: maxWidth, maxHeight: maxHeight)  // Загрузка и конвертация
                    }, maxWidth: .infinity)
                    
                    if !viewModel.asciiArt.isEmpty {  // Если арт сгенерирован
                        // Отладочный вывод для проверки текста
                        let _ = print("ImageToASCIIView: ASCII art = \(viewModel.asciiArt.prefix(100))...")
                        
                        ASCIIArtTextView(text: viewModel.asciiArt, color: appSettings.selectedColor.color)  // Отображаем арт
                            .frame(maxWidth: .infinity, maxHeight: .infinity)  // Полная ширина и высота
                            .border(appSettings.selectedColor.color.opacity(0.5), width: 1)  // Обводка
                        
                        CustomButton(title: "Скопировать ASCII-арт", action: {  // Кнопка копирования
                            viewModel.asciiArt.copyToClipboard()  // Копируем в буфер
                            DispatchQueue.main.async {  // Показываем алерт
                                alertManager.showAlert(title: "Успех", message: "ASCII-арт скопирован в буфер обмена")
                            }
                        }, maxWidth: .infinity, fontSize: 14)  // Единый стиль кнопки
                            .scaledToFit()  // Масштабируем
                            .minimumScaleFactor(0.5)  // Минимальный масштаб
                    } else {  // Плейсхолдер
                        CustomText(text: "Изображение не выбрано", size: 14)  // Текст подсказки
                            .opacity(0.6)  // Полупрозрачность
                            .frame(maxHeight: .infinity)  // Полная высота
                    }
                    
                    CustomButton(title: "Вернуться в меню", action: onBack, maxWidth: .infinity, fontSize: 14)  // Кнопка возврата
                        .scaledToFit()  // Масштабируем
                        .minimumScaleFactor(0.5)  // Минимальный масштаб
                }
                .padding()  // Отступы
                .frame(maxHeight: geometry.size.height)  // Ограничение высоты
                .padding(.bottom, 20)  // Отступ снизу
            }
            .onAppear {  // При загрузке
                maxWidth = Int32(max(80, Int(geometry.size.width / 10)))  // Ширина символа ~10px
                maxHeight = Int32(max(80, Int(geometry.size.height / 15)))  // Высота строки ~15px
            }
            .onChange(of: geometry.size) {  // При изменении размера окна
                maxWidth = Int32(max(80, Int($0.width / 10)))  // Пересчитываем ширину
                maxHeight = Int32(max(80, Int($0.height / 15)))  // Пересчитываем высоту
            }
        }
    }
}