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
#include <algorithm>  // Для std::min
#include "json.hpp"
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

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
        if (key.length() == 1) {  // Проверяем, что ключ — один символ (поддержка строчных и заглавных)
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
std::string ASCIIConverter::convertImageToASCII(const std::string& imagePath, int maxWidth, int maxHeight) {
    // Загрузка изображения с помощью stb_image
    int width, height, channels;
    unsigned char* image = stbi_load(imagePath.c_str(), &width, &height, &channels, 0);
    if (!image) {
        return std::format("Ошибка: Не удалось загрузить изображение '{}'", imagePath);
    }

    // Вычисляем масштаб для вписывания в maxWidth и maxHeight, сохраняя пропорции
    double scale = std::min(static_cast<double>(maxWidth) / width, static_cast<double>(maxHeight) / height);
    int outputWidth = static_cast<int>(width * scale);
    int outputHeight = static_cast<int>(height * scale);

    // Массив символов для градаций яркости
    const std::string chars = "@%#*+=-:. ";

    std::string result;
    result.reserve(outputWidth * outputHeight + outputHeight); // Резервируем память для результата
    for (int y = 0; y < outputHeight; ++y) {
        for (int x = 0; x < outputWidth; ++x) {
            // Вычисляем соответствующий пиксель
            int pixelX = static_cast<int>(static_cast<double>(x) / scale);
            int pixelY = static_cast<int>(static_cast<double>(y) / scale);
            int index = (pixelY * width + pixelX) * channels;

            // Проверка на выход за границы
            if (index + 2 < width * height * channels) {
                // Вычисляем яркость (усреднённая по RGB)
                float brightness = (image[index] + image[index + 1] + image[index + 2]) / (3.0f * 255.0f);
                int charIndex = static_cast<int>(brightness * (chars.size() - 1));
                result += chars[chars.size() - 1 - charIndex];
            } else {
                result += ' ';
            }
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
        // Удаляем лишние пробелы в конце строк
        std::string trimmed = result[i];
        while (!trimmed.empty() && trimmed.back() == ' ') {
            trimmed.pop_back();
        }
        oss << trimmed;
        if (i + 1 != result.size()) oss << "\n";
    }
    return oss.str();
}

// C-совместимые функции для Swift
extern "C" {
    const char* convert_image_to_ascii(const char* fontPath, const char* imagePath, int maxWidth, int maxHeight) {
        try {
            ASCIIConverter converter(fontPath);
            std::string result = converter.convertImageToASCII(imagePath, maxWidth, maxHeight);
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