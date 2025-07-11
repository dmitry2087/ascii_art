//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII-ART для macOS
// SharedComponents.swift

import SwiftUI

// Универсальная кнопка
struct CustomButton: View {
    let title: String
    let action: () -> Void
    let maxWidth: CGFloat
    let fontSize: CGFloat
    
    init(title: String, action: @escaping () -> Void, maxWidth: CGFloat = 300, fontSize: CGFloat = 16) {
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
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.green, lineWidth: 2)
                )
        }
        .buttonStyle(.plain)
        .foregroundColor(.green)
    }
}

// Универсальный текст
struct CustomText: View {
    let text: String
    let size: CGFloat
    let weight: Font.Weight
    
    init(text: String, size: CGFloat = 16, weight: Font.Weight = .regular) {
        self.text = text
        self.size = size
        self.weight = weight
    }
    
    var body: some View {
        Text(text)
            .font(.system(size: size, weight: weight, design: .monospaced))
            .foregroundColor(.green)
    }
}