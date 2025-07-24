//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII ART Studio для Linux                     
// gui.hpp

#ifndef GUI_HPP
#define GUI_HPP

#include <string>
#include <vector>
#include <imgui.h>

class ASCIIConverter;

enum class AnimationType {
    RandomNoise,
    WavePattern,
    FallingChars
};

enum class AnimationColor {
    Green, White, Red, Blue, Orange, Purple, Pink
};

class Gui {
private:
    ASCIIConverter* converter;
    std::string inputText;
    std::string asciiResultText;
    std::string imagePath;
    std::string asciiResultImage;
    bool showTextWindow;
    bool showImageWindow;
    bool showSettingsWindow;
    AnimationType selectedAnimationType;
    AnimationColor selectedAnimationColor;
    std::string animationFrame;
    int animationWidth;
    int animationHeight;
    int frameCount;
    float animationTimer;

    // Функции анимации
    void updateAnimationFrame();
    std::string generateRandomNoise();
    std::string generateWavePattern();
    std::string generateFallingChars();

public:
    Gui(ASCIIConverter* conv);
    ~Gui();

    void draw();
};

#endif // GUI_HPP