//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII Art Studio для macOS
// AnimationViewModel.swift

import Foundation
import SwiftUI

class AnimationViewModel: ObservableObject {  // Модель для управления анимацией
    @Published var currentFrame: String = ""  // Текущий кадр анимации
    
    private var width: Int = 0  // Ширина в символах
    private var height: Int = 0  // Высота в символах
    private var frameCount: Int = 0  // Счётчик кадров
    private var timer: Timer?  // Таймер для анимации
    private let appSettings: AppSettings  // Настройки приложения
    
    init(appSettings: AppSettings) {  // Инициализатор
        self.appSettings = appSettings
    }
    
    func setSize(width: Int, height: Int) {  // Установка размера анимации
        self.width = max(width / 2, 10)  // Деление на 2 (~2px на символ при шрифте 6pt) для большего числа символов
        self.height = max(height / 4, 10)  // Деление на 4 (~4px высота символа) для пропорции
        updateFrame()
    }
    
    func startAnimation() {  // Запуск анимации
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.frameCount += 1
            self.updateFrame()
        }
    }
    
    func stopAnimation() {  // Остановка анимации
        timer?.invalidate()
        timer = nil
    }
    
    private func updateFrame() {  // Обновление текущего кадра
        currentFrame = appSettings.selectedAnimationType.updateFrame(width: width, height: height, frameCount: frameCount)
    }
}