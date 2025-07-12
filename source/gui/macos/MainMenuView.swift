//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// ASCII-ART app for macOS   
// MainMenuView.swift

import SwiftUI

enum AppMode {
    case imageToASCII
    case textToASCII
}

struct MainMenuView: View {
    @State private var selectedMode: AppMode?
    
    var body: some View {
        if let mode = selectedMode {
            // Показываем соответствующий режим
            switch mode {
            case .imageToASCII:
                ImageToASCIIView(onBack: { selectedMode = nil })
            case .textToASCII:
                TextToASCIIView(onBack: { selectedMode = nil })
            }
        } else {
            // Главное меню
            MenuScreenView(
                onImageMode: { selectedMode = .imageToASCII },
                onTextMode: { selectedMode = .textToASCII }
            )
        }
    }
}

struct MenuScreenView: View {
    let onImageMode: () -> Void
    let onTextMode: () -> Void
    
    @StateObject private var animationViewModel = AnimationViewModel()
    
    var body: some View {
        ZStack {
            // Фоновая анимация
            BackgroundAnimationView(viewModel: animationViewModel)
            
            // Главное меню
            VStack(spacing: 40) {
                // Заголовок
                VStack(spacing: 8) {
                    Text("ASCII ART STUDIO")
                        .font(.system(size: 36, weight: .bold, design: .monospaced))
                        .foregroundColor(.green)
                    
                    Text("Выберите режим работы")
                        .font(.system(size: 18, weight: .medium, design: .monospaced))
                        .foregroundColor(.green.opacity(0.8))
                }
                
                // Кнопки выбора режима
                VStack(spacing: 20) {
                    Button(action: onImageMode) {
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
                        .frame(maxWidth: .infinity) // Изменено с maxWidth: 500
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.green, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.green)
                    
                    Button(action: onTextMode) {
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
                        .frame(maxWidth: .infinity) // Изменено с maxWidth: 500
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.green, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.green)
                }
                
                Spacer()
            }
            .padding()
        }
        .background(Color.black)
        .onAppear {
            animationViewModel.startAnimation()
        }
        .onDisappear {
            animationViewModel.stopAnimation()
        }
    }
}

final class AnimationViewModel: ObservableObject {
    @Published var currentFrame = ""
    
    private var timer: Timer?
    private let width = 100
    private let height = 30
    
    func startAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.updateFrame()
        }
    }
    
    func stopAnimation() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateFrame() {
        let chars = Array(" .:-=+*#%@")
        var frame = ""
        
        for _ in 0..<height {
            for _ in 0..<width {
                frame += String(chars.randomElement() ?? " ")
            }
            frame += "\n"
        }
        
        currentFrame = frame
    }
}

struct BackgroundAnimationView: View {
    @ObservedObject var viewModel: AnimationViewModel
    
    var body: some View {
        Text(viewModel.currentFrame)
            .font(.system(size: 8, design: .monospaced))
            .foregroundColor(.green.opacity(0.3))
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
            .padding()
            .allowsHitTesting(false)
    }
}