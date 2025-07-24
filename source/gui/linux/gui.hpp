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

class ASCIIConverter;  // Форвард декларация (класс из ascii_converter.hpp)

class Gui {
private:
    ASCIIConverter* converter;  // Конвертер для ASCII
    std::string inputText;  // Ввод текста
    std::string asciiResultText;  // Результат для текста
    std::string imagePath;  // Путь к изображению
    std::string asciiResultImage;  // Результат для изображения
    bool showTextWindow;  // Флаг окна текста
    bool showImageWindow;  // Флаг окна изображения

public:
    Gui(ASCIIConverter* conv);  // Конструктор
    ~Gui();  // Деструктор

    void draw();  // Рисование UI
};

#endif // GUI_HPP