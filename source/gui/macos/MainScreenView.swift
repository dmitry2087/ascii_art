import SwiftUI

struct MenuScreenView: View {
    let onImageMode: () -> Void
    let onTextMode: () -> Void
    @EnvironmentObject var appSettings: AppSettings
    @StateObject private var animationViewModel: AnimationViewModel
    
    init(onImageMode: @escaping () -> Void, onTextMode: @escaping () -> Void, appSettings: AppSettings) {
        self.onImageMode = onImageMode
        self.onTextMode = onTextMode
        _animationViewModel = StateObject(wrappedValue: AnimationViewModel(appSettings: appSettings))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundAnimationView(viewModel: animationViewModel, size: geometry.size, color: appSettings.selectedColor.color)
                    .onAppear {
                        animationViewModel.setSize(width: Int(geometry.size.width / 6), height: Int(geometry.size.height / 10))
                        animationViewModel.startAnimation()
                    }
                    .onChange(of: geometry.size) { newSize in
                        animationViewModel.setSize(width: Int(newSize.width / 6), height: Int(newSize.height / 10))
                    }
                
                VStack(spacing: 40) {
                    VStack(spacing: 8) {
                        Text("ASCII ART STUDIO")
                            .font(.system(size: 36, weight: .bold, design: .monospaced))
                            .foregroundColor(appSettings.selectedColor.color)
                        
                        Text("Выберите режим работы")
                            .font(.system(size: 18, weight: .medium, design: .monospaced))
                            .foregroundColor(appSettings.selectedColor.color.opacity(0.8))
                    }
                    
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
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .background(Color.black)
            .onDisappear {
                animationViewModel.stopAnimation()
            }
        }
    }
}