//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII Art Studio для macOS
// SharedComponents.swift

import SwiftUI
import AppKit

struct CustomText: View {  // Кастомный текст с настройками шрифта и цвета
    let text: String
    let size: CGFloat
    let weight: Font.Weight
    @EnvironmentObject var appSettings: AppSettings  // Настройки для цвета
    
    init(text: String, size: CGFloat = 16, weight: Font.Weight = .regular) {  // Инициализатор
        self.text = text
        self.size = size
        self.weight = weight
    }
    
    var body: some View {
        Text(text)
            .font(.system(size: size, weight: weight, design: .monospaced))  // Моноспейс шрифт
            .foregroundColor(appSettings.selectedColor.color)
    }
}

struct CustomButton: View {  // Кастомная кнопка с стилем
    let title: String
    let action: () -> Void
    let maxWidth: CGFloat
    let fontSize: CGFloat
    @EnvironmentObject var appSettings: AppSettings  // Настройки для цвета
    
    init(title: String, action: @escaping () -> Void, maxWidth: CGFloat = 300, fontSize: CGFloat = 16) {  // Инициализатор
        self.title = title
        self.action = action
        self.maxWidth = maxWidth
        self.fontSize = fontSize
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize, weight: .semibold, design: .monospaced))
                .padding()
                .frame(maxWidth: maxWidth)
                .background(appSettings.selectedColor.color.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(appSettings.selectedColor.color, lineWidth: 2)
                )
        }
        .buttonStyle(.plain)
        .foregroundColor(appSettings.selectedColor.color)
    }
}