//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII-ART для macOS                               
// AppSettings.swift

import SwiftUI

enum AnimationColor: String, CaseIterable, Identifiable {
    case green, white, red, blue, orange, purple, pink
    
    var id: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .green: return .green
        case .white: return .white
        case .red: return .red
        case .blue: return .blue
        case .orange: return .orange
        case .purple: return .purple
        case .pink: return .pink
        }
    }
}

class AppSettings: ObservableObject {
    @Published var selectedAnimationType: AnimationType = .randomNoise
    @Published var selectedColor: AnimationColor = .green
}