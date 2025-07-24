//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII Art Studio для macOS
// BackgroundAnimationView.swift

import SwiftUI

struct BackgroundAnimationView: View {  // Представление для фоновой анимации
    @ObservedObject var viewModel: AnimationViewModel  // Модель анимации
    let size: CGSize  // Размер окна из GeometryReader
    let color: Color  // Цвет анимации
    
    var body: some View {
        Text(viewModel.currentFrame)  // Текущий кадр анимации
            .font(.system(size: 6, design: .monospaced))
            .foregroundColor(color.opacity(0.2))
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, maxHeight: .infinity)  // Максимальная растяжка для полного покрытия
            .fixedSize(horizontal: false, vertical: false)  // Адаптация текста к контейнеру (Swift with Majid)
            .contentShape(Rectangle())  // Явная форма view для избежания clipping issues
            .background(Color.black)
            .ignoresSafeArea(.all)  // Покрытие меню-бара и краёв для macOS 14.0
            .clipped()  // Ограничение рендеринга
            .onAppear {  // Отладка размеров анимации
                print("Animation size: \(size)")
            }
    }
}