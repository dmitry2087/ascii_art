//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII ART Studio для Linux                     
// gui.cpp

#include "gui.hpp"
#include "imgui.h"
#include "ascii_converter.hpp"

Gui::Gui(ASCIIConverter* conv) : converter(conv), showTextWindow(false), showImageWindow(false) {
    // Конструктор, ничего сложного
}

Gui::~Gui() {
    // Деструктор, тоже просто
}

void Gui::draw() {
    ImGui::Begin("Главное меню");
    if (ImGui::Button("Текст в ASCII")) {
        showTextWindow = true;
    }
    if (ImGui::Button("Изображение в ASCII")) {
        showImageWindow = true;
    }
    ImGui::End();

    // Окно для текста
    if (showTextWindow) {
        ImGui::Begin("Конвертер текста в ASCII", &showTextWindow);
        char buffer[256] = {0};
        strncpy(buffer, inputText.c_str(), sizeof(buffer) - 1);
        buffer[sizeof(buffer) - 1] = '\0';  // Обеспечиваем null-терминированность

        if (ImGui::InputText("Введите текст", buffer, sizeof(buffer))) {
            inputText = buffer;
            asciiResultText = converter->convertTextToASCII(inputText);
        }
        ImGui::TextWrapped("%s", asciiResultText.c_str());
        if (ImGui::Button("Скопировать")) {
            ImGui::SetClipboardText(asciiResultText.c_str());
        }
        ImGui::End();
    }

    // Окно для изображения
    if (showImageWindow) {
        ImGui::Begin("Конвертер изображений в ASCII", &showImageWindow);
        char buffer[256] = {0};
        strncpy(buffer, inputText.c_str(), sizeof(buffer) - 1);
        buffer[sizeof(buffer) - 1] = '\0';  // Обеспечиваем null-терминированность

        if (ImGui::InputText("Путь к изображению", buffer, sizeof(buffer))) {
            imagePath = buffer;
            asciiResultImage = converter->convertImageToASCII(imagePath, 100, 80);
        }
        ImGui::TextWrapped("%s", asciiResultImage.c_str());
        if (ImGui::Button("Скопировать")) {
            ImGui::SetClipboardText(asciiResultImage.c_str());
        }
        ImGui::End();
    }
}