//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// ASCII-ART app for macOS                               
// ContentView.swift

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var viewModel = ASCIIViewModel()
    @State private var showingImagePicker = false
    @State private var showingTextInput = false

    var body: some View {
        NavigationSplitView {
            // Левая панель — вывод ASCII/анимации
            ASCIIDisplayView(viewModel: viewModel)
                .frame(minWidth: 600, minHeight: 400)
                .background(Color.black)
                .onAppear { viewModel.startIdleAnimation() }
                .onDisappear { viewModel.stopAnimation() }
        } detail: {
            // Правая панель — управление
            ControlPanelView(
                viewModel: viewModel,
                showingImagePicker: $showingImagePicker,
                showingTextInput: $showingTextInput
            )
            .frame(minWidth: 250)
        }
        .navigationTitle("ASCII Art Studio")
        .fileImporter(
            isPresented: $showingImagePicker,
            allowedContentTypes: [.image],
            allowsMultipleSelection: false
        ) { result in
            viewModel.handleImageSelection(result)
        }
        .sheet(isPresented: $showingTextInput) {
            TextInputView(viewModel: viewModel)
        }
    }
}

struct ASCIIDisplayView: View {
    @ObservedObject var viewModel: ASCIIViewModel

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            Text(viewModel.currentASCII)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.green)
                .padding()
                .background(Color.black)
                .textSelection(.enabled)
        }
        .overlay {
            if viewModel.isProcessing {
                VStack(spacing: 8) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                        .scaleEffect(1.5)
                    Text("Обработка...")
                        .foregroundColor(.green)
                        .font(.system(size: 14, design: .monospaced))
                }
                .padding(16)
                .background(Color.black.opacity(0.8))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.green, lineWidth: 1))
            }
        }
    }
}

struct ControlPanelView: View {
    @ObservedObject var viewModel: ASCIIViewModel
    @Binding var showingImagePicker: Bool
    @Binding var showingTextInput: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Управление")
                .font(.headline)
                .padding(.top)

            Button("Загрузить изображение") {
                showingImagePicker = true
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isProcessing)

            Button("Текст в ASCII") {
                showingTextInput = true
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.isProcessing)

            Divider()

            Toggle("Фоновая анимация", isOn: $viewModel.isAnimationEnabled)
                .onChange(of: viewModel.isAnimationEnabled) { newValue in
                    if newValue { viewModel.startIdleAnimation() }
                    else { viewModel.stopAnimation() }
                }

            if viewModel.isAnimationEnabled {
                Picker("Тип анимации", selection: $viewModel.selectedAnimationType) {
                    ForEach(AnimationType.allCases, id: \.self) { type in
                        Text(type.displayName).tag(type)
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: viewModel.selectedAnimationType) { newType in
                    viewModel.changeAnimationType(newType)
                }
            }

            Spacer()

            Button("Очистить") {
                viewModel.clearOutput()
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
        }
        .padding()
    }
}