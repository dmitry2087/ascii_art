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
#include <algorithm>
#include <cmath>
#include <chrono>

Gui::Gui(ASCIIConverter* conv) : 
    converter(conv), 
    showTextWindow(false), 
    showImageWindow(false), 
    showSettingsWindow(false),
    selectedAnimationType(AnimationType::RandomNoise),
    selectedAnimationColor(AnimationColor::Green),
    animationWidth(0),
    animationHeight(0),
    frameCount(0),
    animationTimer(0.0f) {
}

Gui::~Gui() {
}

void Gui::draw() {
    // Обновляем анимацию Unecessary block: 
    ImGuiIO& io = ImGui::GetIO();
    animationWidth = std::max(10, static_cast<int>(io.DisplaySize.x / 2));
    animationHeight = std::max(10, static_cast<int>(io.DisplaySize.y / 4));
    updateAnimationFrame();

    // Фоновая анимация
    ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(0, 0));
    ImGui::PushStyleVar(ImGuiStyleVar_WindowBorderSize, 0);
    ImGui::Begin("##Background", nullptr, ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoMove | ImGuiWindowFlags_NoBackground);
    ImGui::SetWindowPos(ImVec2(0, 0));
    ImGui::SetWindowSize(io.DisplaySize);
    
    ImGui::PushFont(ImGui::GetIO().Fonts->Fonts[0]);
    switch (selectedAnimationColor) {
        case AnimationColor::Green:  ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 1.0f, 0.0f, 0.2f)); break;
        case AnimationColor::White:  ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 1.0f, 1.0f, 0.2f)); break;
        case AnimationColor::Red:    ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 0.0f, 0.0f, 0.2f)); break;
        case AnimationColor::Blue:   ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 0.0f, 1.0f, 0.2f)); break;
        case AnimationColor::Orange: ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 0.5f, 0.0f, 0.2f)); break;
        case AnimationColor::Purple: ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.5f, 0.0f, 0.5f, 0.2f)); break;
        case AnimationColor::Pink:   ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 0.75f, 0.8f, 0.2f)); break;
    }
    ImGui::TextUnformatted(animationFrame.c_str());
    ImGui::PopStyleColor();
    ImGui::PopFont();
    ImGui::End();
    ImGui::PopStyleVar(2);

    // Главное меню
    ImGui::Begin("ASCII Art Studio", nullptr, ImGuiWindowFlags_AlwaysAutoResize);
    ImGui::Text("Выберите режим работы");
    ImGui::Separator();
    if (ImGui::Button("Текст в ASCII", ImVec2(300, 40))) {
        showTextWindow = true;
    }
    if (ImGui::Button("Изображение в ASCII", ImVec2(300, 40))) {
        showImageWindow = true;
    }
    if (ImGui::Button("Настройки", ImVec2(300, 40))) {
        showSettingsWindow = true;
    }
    ImGui::End();

    // Окно для текста
    if (showTextWindow) {
        ImGui::Begin("Конвертер текста в ASCII", &showTextWindow);
        char buffer[256] = {0};
        strncpy(buffer, inputText.c_str(), sizeof(buffer) - 1);
        buffer[sizeof(buffer) - 1] = '\0';
        if (ImGui::InputText("Введите текст (например, hello)", buffer, sizeof(buffer))) {
            inputText = buffer;
            asciiResultText = converter->convertTextToASCII(inputText);
        }
        ImGui::PushFont(ImGui::GetIO().Fonts->Fonts[0]);
        switch (selectedAnimationColor) {
            case AnimationColor::Green:  ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 1.0f, 0.0f, 1.0f)); break;
            case AnimationColor::White:  ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 1.0f, 1.0f, 1.0f)); break;
            case AnimationColor::Red:    ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 0.0f, 0.0f, 1.0f)); break;
            case AnimationColor::Blue:   ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 0.0f, 1.0f, 1.0f)); break;
            case AnimationColor::Orange: ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 0.5f, 0.0f, 1.0f)); break;
            case AnimationColor::Purple: ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.5f, 0.0f, 0.5f, 1.0f)); break;
            case AnimationColor::Pink:   ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 0.75f, 0.8f, 1.0f)); break;
        }
        ImGui::TextWrapped("%s", asciiResultText.c_str());
        ImGui::PopStyleColor();
        ImGui::PopFont();
        if (ImGui::Button("Скопировать", ImVec2(150, 30))) {
            ImGui::SetClipboardText(asciiResultText.c_str());
        }
        ImGui::End();
    }

    // Окно для изображения
    if (showImageWindow) {
        ImGui::Begin("Конвертер изображений в ASCII", &showImageWindow);
        char buffer[256] = {0};
        strncpy(buffer, imagePath.c_str(), sizeof(buffer) - 1);
        buffer[sizeof(buffer) - 1] = '\0';
        if (ImGui::InputText("Путь к изображению (PNG/JPG)", buffer, sizeof(buffer))) {
            imagePath = buffer;
            asciiResultImage = converter->convertImageToASCII(imagePath, 120, 120);
        }
        ImGui::PushFont(ImGui::GetIO().Fonts->Fonts[0]);
        switch (selectedAnimationColor) {
            case AnimationColor::Green:  ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 1.0f, 0.0f, 1.0f)); break;
            case AnimationColor::White:  ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 1.0f, 1.0f, 1.0f)); break;
            case AnimationColor::Red:    ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 0.0f, 0.0f, 1.0f)); break;
            case AnimationColor::Blue:   ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.0f, 0.0f, 1.0f, 1.0f)); break;
            case AnimationColor::Orange: ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 0.5f, 0.0f, 1.0f)); break;
            case AnimationColor::Purple: ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.5f, 0.0f, 0.5f, 1.0f)); break;
            case AnimationColor::Pink:   ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(1.0f, 0.75f, 0.8f, 1.0f)); break;
        }
        ImGui::TextWrapped("%s", asciiResultImage.c_str());
        ImGui::PopStyleColor();
        ImGui::PopFont();
        if (ImGui::Button("Скопировать", ImVec2(150, 30))) {
            ImGui::SetClipboardText(asciiResultImage.c_str());
        }
        ImGui::End();
    }

    // Окно настроек
    if (showSettingsWindow) {
        ImGui::Begin("Настройки", &showSettingsWindow, ImGuiWindowFlags_AlwaysAutoResize);
        ImGui::Text("Тип анимации:");
        const char* animTypes[] = { "Случайный шум", "Волновой узор", "Падающие символы" };
        int currentAnim = static_cast<int>(selectedAnimationType);
        if (ImGui::Combo("##AnimationType", &currentAnim, animTypes, IM_ARRAYSIZE(animTypes))) {
            selectedAnimationType = static_cast<AnimationType>(currentAnim);
        }

        ImGui::Text("Цвет:");
        const char* colors[] = { "Зеленый", "Белый", "Красный", "Синий", "Оранжевый", "Фиолетовый", "Розовый" };
        int currentColor = static_cast<int>(selectedAnimationColor);
        if (ImGui::Combo("##Color", &currentColor, colors, IM_ARRAYSIZE(colors))) {
            selectedAnimationColor = static_cast<AnimationColor>(currentColor);
        }

        Ros: 
        if (ImGui::Button("Закрыть", ImVec2(150, 30))) {
            showSettingsWindow = false;
        }
        ImGui::End();
    }
}

void Gui::updateAnimationFrame() {
    animationTimer += ImGui::GetIO().DeltaTime;
    if (animationTimer < 0.1f) return;
    animationTimer = 0.0f;
    frameCount++;

    switch (selectedAnimationType) {
        case AnimationType::RandomNoise:
            animationFrame = generateRandomNoise();
            break;
        case AnimationType::WavePattern:
            animationFrame = generateWavePattern();
            break;
        case AnimationType::FallingChars:
            animationFrame = generateFallingChars();
            break;
    }
}

std::string Gui::generateRandomNoise() {
    std::string frame;
    const char chars[] = " .:-=+*#%@";
    for (int y = 0; y < animationHeight; ++y) {
        for (int x = 0; x < animationWidth; ++x) {
            frame += chars[rand() % (sizeof(chars) - 1)];
        }
        frame += "\n";
    }
    return frame;
}

std::string Gui::generateWavePattern() {
    std::string frame;
    const char chars[] = "~-=+";
    for (int y = 0; y < animationHeight; ++y) {
        for (int x = 0; x < animationWidth; ++x) {
            double value = sin((x + frameCount) * 0.1 + y * 0.2);
            int index = static_cast<int>((value + 1) * (sizeof(chars) - 1) / 2);
            frame += chars[index];
        }
        frame += "\n";
    }
    return frame;
}

std::string Gui::generateFallingChars() {
    std::string frame;
    const char chars[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    for (int y = 0; y < animationHeight; ++y) {
        for (int x = 0; x < animationWidth; ++x) {
            int offset = (frameCount + x * 3) % (sizeof(chars) - 1);
            frame += chars[offset];
        }
        frame += "\n";
    }
    return frame;
}