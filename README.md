# ASCII ART STUDIO 🇷🇺
Десктопное приложение ASCII Art Studio под операционные системы macOS и Linux. Позволяет работать с переводом изображений и печатью слов в ASCII.

## Функционал
- **Перевод изображений в ASCII символы**: На вход пользователь загружает растровое изображение формата *.png, *.jpg и т.д. Программа конвертирует загруженное изображение в ASCII-арт (набор ASCII-символов, которые в совокупности визуально представляют собой исходное изображение), и выводит его на экран.
- **Печать слов в ASCII коде**: Например, пользователь ввел "Hello, world!". Приложению требуется обработать буквы всего текста и вывести их в нужном виде.

Если в приложении не происходит никаких действий, выводится набор динамично меняющихся ASCII-символов, в совокупности представляющие собой анимированное изображение.

## Технологии и требования
### macOS:
- Apple Silicon (M1+)
- macOS 14.0+  
- Swift (5.9+)  
- Clang 15+
- Xcode 15+
- Homebrew

### Linux:
- Ubuntu Linux 22.04+ 
- ImGui 1.92.1+
- GCC\G++ 12.0+
- OpenGL\GLFW 3.3+

### Общие требования:
- C++20
- CMake 3.20+
- Visual Studio Code


## Установка и запуск
### macOS:
Так как macOS и Linux UNIX-системы, у них есть множество схожих моментов, но есть и различия. На macOS, в основном, уже практически все предустановлено, в отличие от Linux и работать с ней в этом плане легче. Давайте приступим к установке приложения:
1. **Проверим версию системы**: Если Вы вдруг не знаете, какая версия macOS у Вас установлена, то выполните команду ```sm_vers -productVersion``` в приложении Terminal. У Вас должна быть версия не меньше 14.0 или выше.
2. **Установим Xcode и Command Line Tools**: Git на macOS уже предустановлен (можно проверить командой ```git --version```), поэтому его пропустим. Проверим, что у нас установлены Xcode и Command Line Tools, для этого проверьте, установлена ли у Вас в [Mac App Store](https://apps.apple.com/app/xcode) Xcode или нет. Если нет, установите. После установки выполните в Terminal команду ```xcode-select --install```, начнется установка Command Line Tools, а если уже установлена, то выведет соответствующие сообщение. 
3. **Версия Clang**: Проверим версию Clang, которая у нас была установлена с Command Line Tools, выполним команду ```clang --version```, должна быть 15.0.0 или выше. 
4. **Версия Swift**: Выполните в Terminal команду ```swift --version```, должна быть 5.9 или выше. Он автоматически устанавливается с Xcode.
5. **Установка Homebrew и CMake**: Если у Вас не установлен Homebrew, то выполните команду в Terminal: ```/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)```, это установит его. После его установки выполните ```brew install cmake```. Это установит CMake и им можно будет пользоваться. Проверить его версию можно с помощью ```cmake --version```, его версия должна быть 3.20 или выше. 
6. **Клонирование репозитория**: После того, как мы все установили для работы приложения, то можно приступать к запуску. Выберите удобную папку для проекта. Теперь в нее нужно будет спуститься в Terminal, для этого выполните команду ```cd путь_к_вашей_папке```, после этого мы можем инициализировать репозиторий, выполните команду ```git init```. После инициализации репозитория мы можем клонировать наш репозиторий, а именно - ```git clone https://github.com/dmitry2087/ascii_art.git``` командой в Terminal. Теперь репозиторий установлен в нашу папку.
7. **Visual Studio Code**: Для работы нужна будет VS Code. Установите ее, для этого введите в поисковике "download vs code" и скачайте версию VS Code для вашей системы (для macOS это будет dmg-установщик для arm64, она же Apple Silicon версия). После установки VS Code нам нужно скачать расширения, а именно: CMake Tools, Swift, [С\С++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools), gitignore, Git Extension Pack.
8. **Сборка и запуск проекта**: Откройте папку с проектом в Visual Studio Code. VS Code с установленными расширениями CMake Tools должен автоматически определить проект и предложить его сконфигурировать. Нам нужно выбрать версию компилятора Clang не ниже 15.0.0. После этого CMake создат Unix файлы, они на мне нужны, поэтому в Terminal переходим к папке нашего проекта. Там вводим команду ```rm -rf build```, потом создаем ```mkdir build```, зачем туда спускаемся командой ```cd build``` и выполняем в Terminal команды, сначала ```cmake .. -G Xcode```, а затем собираем проект ```cmake --build .```, после этого все будет скомпилировано и успешно собрано. В папке build, в подпапке Debug будет храниться наш ```AsciiArtStudio.app```, его можно запустить и пользоваться приложением.

### Ubuntu Linux:
1. **Проверим версию системы:** Убедитесь, что у вас установлена Ubuntu Linux версии 22.04 или новее. Для этого выполните команду ```lsb_release -a```. Для начала установки рекомендуется обновить все пакеты системы, выполните ```sudo apt update```.
2. **Установим Git:** Если Git не установлен, выполните команду: ```sudo apt install git```.
3. **Установим GCC/G++**: Проверьте версию GCC/G++. Требуется версия 12.0 или выше для стабильной работы C++20. Если она не установлена или устарела, обновите ее: ```sudo apt install build-essential``.
4. **Установим CMake:** Проверьте версию CMake. Требуется версия 3.20 или выше. Если CMake не установлен или устарел, установите его: ```sudo apt install cmake```.
5. **Установим OpenGL/GLFW:** Для графической части приложения необходимы OpenGL и GLFW. Установите их командой: ```sudo apt install libglfw3-dev libgl1-mesa-dev libdecor-0-0 libdecor-0-dev```.
6. **Клонирование репозитория:** Выберите удобную папку для проекта и перейдите в нее в терминале: cd путь_к_вашей_папке. Затем клонируйте репозиторий: ```git clone https://github.com/dmitry2087/ascii_art.git```.
7. **Visual Studio Code:** Установите Visual Studio Code. Загрузите установочный файл с официального сайта "download vs code" и установите его (для Ubuntu Linux это .deb-установщик для arm64 или x86, в зависимости от Вашей архитектуры). После установки, откройте VS Code и установите следующие расширения: CMake Tools, С\С++, gitignore, Git Extension Pack.
8. **Сборка и запуск проекта:** Откройте папку с проектом в Visual Studio Code. VS Code с установленными расширениями CMake Tools должен автоматически определить проект и предложить его сконфигурировать. Нам нужно выбрать версию компилятора GCC или G++ 14.2 или выше. После этого CMake создат Unix файлы, они на мне нужны, поэтому в Terminal переходим к папке нашего проекта. Там вводим команду ```rm -rf build```, потом создаем ```mkdir build```, зачем туда спускаемся командой ```cd build``` и выполняем в Terminal команды, сначала ```cmake ..```, а затем собираем проект ```cmake --build .```, после этого все будет скомпилировано и успешно собрано. В папке build будет храниться наш ```AsciiArtStudio```, его можно запустить командой терминала ```./AsciiArtStudio``` и пользоваться приложением.

## Зависимости
[json.hpp](https://github.com/nlohmann/json) [ImGui_files](https://github.com/ocornut/imgui)
[stb_image.h](https://github.com/nothings/stb)

# ASCII ART STUDIO 🇺🇸🇬🇧
ASCII Art Studio desktop application for macOS and Linux operating systems. Allows you to work with translating images and printing words in ASCII.

## Functionality
- **Translate images into ASCII characters**: As input, the user uploads a bitmap image in *.png, *.jpg, etc. format. The program converts the uploaded image into ASCII art (a set of ASCII characters, which together visually represent the original image), and displays it on the screen.
- **Printing words in ASCII code**: For example, a user has typed "Hello, world!". The application needs to process the letters of the entire text and output them in the desired form.

If no action is performed in the application, a set of dynamically changing ASCII characters are output, which together represent an animated image.

## Technologies and Requirements
### macOS:
- Apple Silicon (M1+)
- macOS 14.0+  
- Swift (5.9+)  
- Clang 15+
- Xcode 15+

### Linux:
- Ubuntu Linux 22.04+ 
- ImGui 1.92.1+
- GCC\G++ 12.0+
- OpenGL\GLFW 3.3+

### General Requirements:
- C++20
- CMake 3.20+
- Visual Studio Code


## Installation
### macOS:
Since macOS and Linux are UNIX systems, they have many similarities, but there are also differences. On macOS, almost everything is pre-installed, unlike Linux, making it easier to work with in this regard. Let's start installing the application:
1. **Check the system version**: If you don't know which version of macOS you have installed, run the command ```sm_vers -productVersion``` in the Terminal application. You must have version 14.0 or higher.
2. **Install Xcode and Command Line Tools**: Git is already pre-installed on macOS (you can check this with the command ```git --version```), so we will skip it. Check that you have Xcode and Command Line Tools installed by checking whether you have Xcode installed in the [Mac App Store](https://apps.apple.com/app/xcode). If not, install it. After installation, run the command ```xcode-select --install``` in Terminal. This will start the installation of Command Line Tools. If it is already installed, a corresponding message will be displayed. 
3. **Clang version**: Check the version of Clang that was installed with Command Line Tools by running the command ```clang --version```. It should be 15.0.0 or higher. 
4. **Swift version**: Run the command ```swift --version``` in Terminal. It should be 5.9 or higher. It is automatically installed with Xcode.
5. **Installing Homebrew and CMake**: If you do not have Homebrew installed, run the command in Terminal: ```/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh) ``` to install it. After installing it, run ```brew install cmake```. This will install CMake and make it ready to use. You can check its version using ```cmake --version```; it should be 3.20 or higher. 
6. **Cloning the repository**: Once we have installed everything needed to run the application, we can start it. Choose a convenient folder for the project. Now we need to go to it in Terminal. To do this, run the command ```cd path_to_your_folder```, after which we can initialize the repository by running the command ```git init```. After initializing the repository, we can clone our repository with the ```git clone https://github.com/dmitry2087/ascii_art.git``` command in Terminal. Now the repository is installed in our folder.
7. **Visual Studio Code**: You will need VS Code to work. Install it by entering “download vs code” in the search engine and downloading the VS Code version for your system (for macOS, this will be a dmg installer for arm64, also known as the Apple Silicon version). After installing VS Code, we need to download the extensions, namely: CMake Tools, Swift, [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools), gitignore, Git Extension Pack.
8. **Building and running the project**: Open the project folder in Visual Studio Code. VS Code with the CMake Tools extensions installed should automatically detect the project and offer to configure it. We need to select a Clang compiler version no lower than 15.0.0. After that, CMake will create Unix files, which I need, so in Terminal, we go to our project folder. There, enter the command ```rm -rf build```, then create ```mkdir build```, go there with the command ```cd build``` and execute the commands in Terminal, first ```cmake .. -G Xcode```, and then build the project ```cmake --build .``` After that, everything will be compiled and successfully built. Our ```AsciiArtStudio.app``` will be stored in the Debug subfolder of the build folder. You can launch it and use the application.

### Ubuntu Linux:
1. **Check the system version:** Make sure you have Ubuntu Linux version 22.04 or newer installed. To do this, run the command ```lsb_release -a```. Before starting the installation, it is recommended to update all system packages by running ```sudo apt update```.
2. **Install Git:** If Git is not installed, run the command: ```sudo apt install git```.
3. **Install GCC/G++**: Check the version of GCC/G++. Version 12.0 or higher is required for C++20. If it is not installed or is outdated, update it: ```sudo apt install build-essential``.
4. **Install CMake:** Check the version of CMake. Version 3.20 or higher is required. If CMake is not installed or is outdated, install it: ```sudo apt install cmake```.
5. **Install OpenGL/GLFW:** OpenGL and GLFW are required for the graphical part of the application. Install them with the command: ```sudo apt install libglfw3-dev libgl1-mesa-dev libdecor-0-0 libdecor-0-dev```.
6. **Clone the repository:** Choose a convenient folder for the project and navigate to it in the terminal: cd path_to_your_folder. Then clone the repository: ```git clone https://github.com/dmitry2087/ascii_art.git```.
7. **Visual Studio Code:** Install Visual Studio Code. Download the installation file from the official website “download vs code” and install it (for Ubuntu Linux, this is a .deb installer for arm64 or x86, depending on your architecture). After installation, open VS Code and install the following extensions: CMake Tools, C/C++, gitignore, Git Extension Pack.
8. **Building and running the project:** Open the project folder in Visual Studio Code. VS Code with the CMake Tools extensions installed should automatically detect the project and offer to configure it. We need to select the GCC or G++ 14.2 or higher compiler version. After that, CMake will create Unix files, which I need, so in Terminal, go to our project folder. There, enter the command ```rm -rf build```, then create ```mkdir build```, go there with the command ```cd build``` and execute the commands in Terminal, first ```cmake ..``` and then compile the project with ```cmake --build .``` After that, everything will be compiled and successfully assembled. Our ```AsciiArtStudio``` will be stored in the build folder. You can run it with the terminal command ```./AsciiArtStudio``` and use the application.

## Dependencies
[json.hpp](https://github.com/nlohmann/json) [ImGui_files](https://github.com/ocornut/imgui)
[stb_image.h](https://github.com/nothings/stb)
