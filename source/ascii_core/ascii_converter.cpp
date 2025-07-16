//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII-ART
// ascii_converter.cpp

#include "ascii_converter.hpp"
#include <format>
#include <fstream>
#include <sstream>
#include "../../external/json/json.hpp"
#define STB_IMAGE_IMPLEMENTATION
#include "../../external/stb/stb_image.h"

using json = nlohmann::json;

ASCIIConverter::ASCIIConverter(const std::string& fontFilePath) {
    loadAsciiFont(fontFilePath);
}

// Загрузка шрифта из JSON
void ASCIIConverter::loadAsciiFont(const std::string& fontFilePath) {
    std::ifstream file(fontFilePath);
    if (!file.is_open()) {
        throw std::runtime_error(std::format("Ошибка: Не удалось открыть файл шрифта '{}'", fontFilePath));
    }

    json j;
    file >> j;

    for (auto& [key, value] : j.items()) {
        if (key.length() == 1) {
            char c = key[0];
            std::vector<std::string> pattern;
            for (const auto& line : value) {
                pattern.push_back(line.get<std::string>());
            }
            if (pattern.size() == 7) { // Проверяем, что шаблон имеет 7 строк
                asciiFont[c] = pattern;
            }
        }
    }
}

// Преобразование изображения в ASCII-арт
std::string ASCIIConverter::convertImageToASCII(const std::string& imagePath, int outputWidth) {
    // Загрузка изображения с помощью stb_image
    int width, height, channels;
    unsigned char* image = stbi_load(imagePath.c_str(), &width, &height, &channels, 0);
    if (!image) {
        return std::format("Ошибка: Не удалось загрузить изображение '{}'", imagePath);
    }

    // Вычисляем высоту, сохраняя пропорции
    int outputHeight = static_cast<int>(static_cast<double>(outputWidth) * height / width);

    // Массив символов для градаций яркости
    const std::string chars = "@%#*+=-:. ";

    std::string result;
    for (int y = 0; y < outputHeight; ++y) {
        for (int x = 0; x < outputWidth; ++x) {
            // Вычисляем соответствующий пиксель
            int pixelX = static_cast<int>(static_cast<double>(x) * width / outputWidth);
            int pixelY = static_cast<int>(static_cast<double>(y) * height / outputHeight);
            int index = (pixelY * width + pixelX) * channels;

            // Вычисляем яркость (усреднённая по RGB)
            float brightness = (image[index] + image[index + 1] + image[index + 2]) / (3.0f * 255.0f);
            int charIndex = static_cast<int>(brightness * (chars.size() - 1));
            result += chars[chars.size() - 1 - charIndex];
        }
        result += "\n";
    }

    // Освобождаем память
    stbi_image_free(image);
    return result;
}

// Преобразование текста в ASCII-арт
std::string ASCIIConverter::convertTextToASCII(const std::string& text) {
    const int lines = 7; // Высота каждого символа
    std::vector<std::string> result(lines, "");

    for (char c : text) {
        if (asciiFont.find(c) != asciiFont.end()) {
            const auto& pattern = asciiFont[c];
            for (int i = 0; i < lines; ++i) {
                result[i] += pattern[i] + "  ";
            }
        } else {
            // Для неподдерживаемых символов используем пробелы
            for (int i = 0; i < lines; ++i) {
                result[i] += std::string(5, ' ') + "  ";
            }
        }
    }

    std::ostringstream oss;
    for (size_t i = 0; i < result.size(); ++i) {
        oss << result[i];
        if (i + 1 != result.size()) oss << "\n";
    }
    return oss.str();
}

// C-совместимые функции для Swift
extern "C" {
    const char* convert_image_to_ascii(const char* fontPath, const char* imagePath, int outputWidth) {
        try {
            ASCIIConverter converter(fontPath);
            std::string result = converter.convertImageToASCII(imagePath, outputWidth);
            char* cstr = new char[result.size() + 1];
            std::strcpy(cstr, result.c_str());
            return cstr;
        } catch (const std::exception& e) {
            std::string error = "Ошибка: " + std::string(e.what());
            char* cstr = new char[error.size() + 1];
            std::strcpy(cstr, error.c_str());
            return cstr;
        }
    }

    const char* convert_text_to_ascii(const char* fontPath, const char* text) {
        try {
            ASCIIConverter converter(fontPath);
            std::string result = converter.convertTextToASCII(text);
            char* cstr = new char[result.size() + 1];
            std::strcpy(cstr, result.c_str());
            return cstr;
        } catch (const std::exception& e) {
            std::string error = "Ошибка: " + std::string(e.what());
            char* cstr = new char[error.size() + 1];
            std::strcpy(cstr, error.c_str());
            return cstr;
        }
    }

    void free_ascii_string(const char* str) {
        delete[] str;
    }
}