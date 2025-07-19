//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII-ART для macOS
// TextToASCIIView.swift

import SwiftUI

struct TextToASCIIView: View {
    @StateObject private var viewModel = TextToASCIIViewModel()
    @EnvironmentObject var alertManager: AlertManager
    @EnvironmentObject var appSettings: AppSettings
    let onBack: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                CustomText(text: "Конвертер текста в ASCII", size: 24, weight: .bold)
                
                TextField("Введите текст (например, Hello)", text: $viewModel.inputText)
                    .font(.system(size: 16, design: .monospaced))
                    .foregroundColor(appSettings.selectedColor.color)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(appSettings.selectedColor.color.opacity(0.1))
                    .cornerRadius(10)
                    .overlay(overlay: RoundedRectangle(cornerRadius: 10)
                        .stroke(appSettings.selectedColor.color, lineWidth: 2)
                    )
                
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
                    CustomText(text: "Введите текст для создания ASCII-арта", size: 14)
                        .opacity(0.6)
                        .frame(height: 400)
                }
                
                CustomButton(title: "Вернуться в меню", action: onBack, maxWidth: .infinity, fontSize: 14)
            }
            .padding()
        }
        .onChange(of: viewModel.inputText) {
            viewModel.convertTextToASCII()
        }
    }
}