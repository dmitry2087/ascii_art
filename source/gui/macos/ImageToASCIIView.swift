//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII-ART для macOS
// ImageToASCIIView.swift

import SwiftUI
import AppKit

struct ImageToASCIIView: View {
    @StateObject private var viewModel = ImageToASCIIViewModel()
    @EnvironmentObject var alertManager: AlertManager
    @EnvironmentObject var appSettings: AppSettings
    let onBack: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                CustomText(text: "Конвертер изображений в ASCII", size: 24, weight: .bold)
                
                CustomButton(title: "Выбрать изображение (PNG/JPG)", action: {
                    viewModel.loadImage()
                }, maxWidth: .infinity)
                
                if !viewModel.asciiArt.isEmpty {
                    ScrollView(.vertical, showsIndicators: true) {
                        Text(viewModel.asciiArt)
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(appSettings.selectedColor.color)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.black)
                            .border(appSettings.selectedColor.color.opacity(0.5), width: 1)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    CustomButton(title: "Скопировать ASCII-арт", action: {
                        viewModel.asciiArt.copyToClipboard()
                    }, maxWidth: .infinity, fontSize: 14)
                } else {
                    CustomText(text: "Изображение не выбрано", size: 14)
                        .opacity(0.6)
                        .frame(height: 400)
                }
                
                CustomButton(title: "Вернуться в меню", action: onBack, maxWidth: .infinity, fontSize: 14)
            }
            .padding()
        }
    }
}