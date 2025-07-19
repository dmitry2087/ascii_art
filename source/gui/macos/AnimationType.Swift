//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII-ART для macOS
// AnimationType.swift

import SwiftUI
import Foundation

enum AnimationType: String, CaseIterable {
    case randomNoise // Случайный шум
    case wavePattern // Волновой узор
    case fallingChars // Падающие символы
    
    // Обновление кадра анимации
    func updateFrame(width: Int, height: Int, frameCount: Int) -> String {
        switch self {
        case .randomNoise:
            let chars = Array(" .:-=+*#%@")
            var frame = ""
            for _ in 0..<height {
                for _ in 0..<width {
                    frame += String(chars.randomElement() ?? " ")
                }
                frame += "\n"
            }
            return frame
            
        case .wavePattern:
            var frame = ""
            let chars = Array("~-=+")
            for y in 0..<height {
                for x in 0..<width {
                    let value = sin(Double(x + frameCount) * 0.1 + Double(y) * 0.2)
                    let index = Int((value + 1) * Double(chars.count - 1) / 2)
                    frame += String(chars[index])
                }
                frame += "\n"
            }
            return frame
            
        case .fallingChars:
            var frame = ""
            let chars = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ")
            for _ in 0..<height {
                for x in 0..<width {
                    let offset = Int(Double(frameCount + x * 3) * 0.1) % chars.count
                    frame += String(chars[offset])
                }
                frame += "\n"
            }
            return frame
        }
    }
}