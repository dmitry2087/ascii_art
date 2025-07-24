//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII-ART
// ascii_converter.hpp

#ifndef ASCII_CONVERTER_HPP
#define ASCII_CONVERTER_HPP

#include <string>
#include <vector>
#include <map>

// Класс для преобразования изображений и текста в ASCII-арт
class ASCIIConverter {
public:
    // Конструктор
    ASCIIConverter(const std::string& fontFilePath);

    // Преобразование изображения в ASCII-арт с учётом ширины и высоты
    std::string convertImageToASCII(const std::string& imagePath, int maxWidth = 100, int maxHeight = 80);

    // Преобразование текста в ASCII-арт
    std::string convertTextToASCII(const std::string& text);

private:
    // Словарь для ASCII-символов
    std::map<char, std::vector<std::string>> asciiFont;

    // Загрузка шрифта из JSON
    void loadAsciiFont(const std::string& fontFilePath);
};

#endif // ASCII_CONVERTER_HPP