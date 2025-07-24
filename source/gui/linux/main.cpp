//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII ART Studio для Linux                     
// main.cpp (Главный файл приложения Linux)

#include <iostream>
#include <format>
#include "imgui.h"
#include "imgui_impl_glfw.h"
#include "imgui_impl_opengl3.h"
#include <GLFW/glfw3.h>
#include "ascii_converter.hpp"
#include "gui.hpp"
#include <stb_image.h>

int main() {
    // Инициализация GLFW
    if (!glfwInit()) {
        std::cerr << std::format("GLFW init failed") << std::endl;
        return -1;
    }
    GLFWwindow* window = glfwCreateWindow(800, 600, "ASCII Art Studio", nullptr, nullptr);
    if (!window) {
        std::cerr << std::format("Window creation failed") << std::endl;
        glfwTerminate();
        return -1;
    }
    glfwMakeContextCurrent(window);

    GLFWimage images[1];
    int width, height, channels;
        unsigned char* img = stbi_load("Resources/icon.png", &width, &height, &channels, 0);
    if (img) {
        images[0].width = width;
        images[0].height = height;
        images[0].pixels = img;
        glfwSetWindowIcon(window, 1, images);
        stbi_image_free(img);
    } else {
        std::cerr << "Failed to load icon.png" << std::endl;
    }

    // Инициализация ImGui
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGui_ImplGlfw_InitForOpenGL(window, true);
    ImGui_ImplOpenGL3_Init("#version 330");

    // Создаём конвертер
    ASCIIConverter converter("Resources/ascii_font.json");

    // Создаём GUI
    Gui gui(&converter);

    // Главный цикл
    while (!glfwWindowShouldClose(window)) {
        glfwPollEvents();
        ImGui_ImplOpenGL3_NewFrame();
        ImGui_ImplGlfw_NewFrame();
        ImGui::NewFrame();

        gui.draw();  // Рисуем UI

        ImGui::Render();
        int display_w, display_h;
        glfwGetFramebufferSize(window, &display_w, &display_h);
        glViewport(0, 0, display_w, display_h);
        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());
        glfwSwapBuffers(window);
    }

    // Очистка
    ImGui_ImplOpenGL3_Shutdown();
    ImGui_ImplGlfw_Shutdown();
    ImGui::DestroyContext();
    glfwDestroyWindow(window);
    glfwTerminate();

    return 0;
}