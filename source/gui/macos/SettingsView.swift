import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appSettings: AppSettings
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Picker("Тип анимации", selection: $appSettings.selectedAnimationType) {
                ForEach(AnimationType.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized).tag(type)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            Picker("Цвет", selection: $appSettings.selectedColor) {
                ForEach(AnimationColor.allCases) { color in
                    Text(color.rawValue.capitalized).tag(color)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            Button("Close") {
                dismiss()
            }
        }
        .padding()
        .frame(width: 300, height: 200)
    }
}