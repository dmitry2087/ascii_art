//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII Art Studio для macOS
// MenuScreenView.swift

import SwiftUI

struct MenuScreenView: View {  // Главное меню с анимацией и кнопками
    let onImageMode: () -> Void  // Колбэк для режима изображений
    let onTextMode: () -> Void  // Колбэк для режима текста
    @EnvironmentObject var appSettings: AppSettings  // Настройки
    @StateObject private var animationViewModel: AnimationViewModel  // Модель анимации
    
    init(onImageMode: @escaping () -> Void, onTextMode: @escaping () -> Void, appSettings: AppSettings) {  // Инициализатор
        self.onImageMode = onImageMode
        self.onTextMode = onTextMode
        _animationViewModel = StateObject(wrappedValue: AnimationViewModel(appSettings: appSettings))
    }
    
    var body: some View {
        GeometryReader { geometry in  // Геометрия для адаптации под размер окна
            ZStack {  // Стек для фона и контента
                BackgroundAnimationView(viewModel: animationViewModel, size: geometry.size, color: appSettings.selectedColor.color)
                    .ignoresSafeArea(.all)  // Игнорирование всех safe areas (включая меню-бар ~24px) для полного покрытия экрана (macOS 14.0)
                    .clipped()  // Ограничение контента границами окна
                    .onAppear {  // Запуск анимации при появлении
                        animationViewModel.setSize(width: Int(geometry.size.width), height: Int(geometry.size.height))
                        animationViewModel.startAnimation()
                    }
                    .onChange(of: geometry.size) { newSize in  // Обновление размера анимации (macOS 14.0 compatible)
                        animationViewModel.setSize(width: Int(newSize.width), height: Int(newSize.height))
                    }
                
                VStack(spacing: 40) {  // Контент меню
                    VStack(spacing: 8) {
                        Text("ASCII ART STUDIO")
                            .font(.system(size: 36, weight: .bold, design: .monospaced))
                            .foregroundColor(appSettings.selectedColor.color)
                        
                        Text("Выберите режим работы")
                            .font(.system(size: 18, weight: .medium, design: .monospaced))
                            .foregroundColor(appSettings.selectedColor.color.opacity(0.8))
                    }
                    .padding(.top, 30)  // Отступ сверху для избежания перекрытия меню-баром (~24px)
                    
                    HStack(spacing: 20) {  // Горизонтальный стек для двух кнопок
                        Button(action: onImageMode) {  // Кнопка для изображений
                            HStack {
                                Image(systemName: "photo.artframe")
                                    .font(.system(size: 24))
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Перевод изображений в ASCII символы")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("Загрузите изображение и конвертируйте в ASCII-арт")
                                        .font(.system(size: 12))
                                        .opacity(0.8)
                                }
                                Spacer()
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .background(appSettings.selectedColor.color.opacity(0.1))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(appSettings.selectedColor.color, lineWidth: 2)
                            )
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(appSettings.selectedColor.color)
                        .scaledToFit()  // Адаптация кнопки для малых окон (Hacking with Swift)
                        
                        Button(action: onTextMode) {  // Кнопка для текста
                            HStack {
                                Image(systemName: "textformat.alt")
                                    .font(.system(size: 24))
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Печать слов в ASCII коде")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("Введите текст и получите ASCII-арт")
                                        .font(.system(size: 12))
                                        .opacity(0.8)
                                }
                                Spacer()
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .background(appSettings.selectedColor.color.opacity(0.1))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(appSettings.selectedColor.color, lineWidth: 2)
                            )
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(appSettings.selectedColor.color)
                        .scaledToFit()  // Адаптация кнопки
                    }
                    
                    Spacer()  // Пространство внизу
                }
                .padding()
                .frame(maxHeight: geometry.size.height)  // Ограничение высоты контента окном
                .padding(.bottom, 20)  // Отступ снизу для кнопок
                .clipped()  // Предотвращение выхода за границы
            }
            .background(Color.black)
            .ignoresSafeArea(.all)  // Полноэкранный стек для macOS 14.0
        }
        .onDisappear {  // Остановка анимации
            animationViewModel.stopAnimation()
        }
    }
}