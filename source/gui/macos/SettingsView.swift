//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII Art Studio для macOS
// SettingsView.swift

import SwiftUI
import AppKit

struct SettingsView: View {  // Представление настроек приложения
    @EnvironmentObject var appSettings: AppSettings  // Настройки из окружения
    @Environment(\.dismiss) var dismiss  // Действие закрытия окна

    private let repositoryURL = "https://github.com/dmitry2087/ascii_art" // URL репозитория для кнопки "GitHub Repository"
    
    var body: some View {
        VStack(spacing: 20) {  // Вертикальный стек элементов
            // Кнопка для открытия репозитория
            CustomButton(title: "GitHub Repository", action: {
                if let url = URL(string: repositoryURL){
                    NSWorkspace.shared.open(url)
                } else {
                    AlertManager.shared.showAlert(title: "Ошибка", message: "Ссылка на репозиторий недоступна")
                }
            }, maxWidth: .infinity, fontSize: 16)
                .scaledToFit()
                .minimumScaleFactor(0.5)
                .clipped()
            
            Picker("Тип анимации", selection: $appSettings.selectedAnimationType) {  // Выбор типа анимации
                ForEach(AnimationType.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized).tag(type)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            Picker("Цвет", selection: $appSettings.selectedColor) {  // Выбор цвета
                ForEach(AnimationColor.allCases) { color in
                    Text(color.rawValue.capitalized).tag(color)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            // Кнопка закрытия с новым дизайном
            Button(action: { dismiss() }) {
                Text("Закрыть")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [appSettings.selectedColor.color, appSettings.selectedColor.color.opacity(0.7)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: appSettings.selectedColor.color.opacity(0.5), radius: 5, x: 0, y: 3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(appSettings.selectedColor.color, lineWidth: 2)
                    )
            }
            .buttonStyle(.plain)
            .foregroundColor(.white)
            .scaledToFit()
            .minimumScaleFactor(0.5)
            .clipped()
        }
        .padding()
        .frame(width: 300, height: 280)  // Увеличена высота для новой кнопки
    }
}