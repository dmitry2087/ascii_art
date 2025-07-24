//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII Art Studio для macOS
// TextToASCIIView.swift

import SwiftUI
import AppKit

// Кастомный компонент для отображения ASCII-арта с использованием NSTextView
struct ASCIIArtTextView: NSViewRepresentable {
    var text: String  // Текст ASCII-арта для отображения
    var color: Color  // Цвет текста
    
    // Создаём координатор для обработки делегата NSTextView
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    // Создание кастомного NSView с NSScrollView и NSTextView
    func makeNSView(context: Context) -> CustomTextView {
        let textView = CustomTextView(
            text: text,
            color: NSColor(color),
            isEditable: false,
            font: NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        )
        textView.delegate = context.coordinator
        return textView
    }
    
    // Обновление текста и цвета
    func updateNSView(_ view: CustomTextView, context: Context) {
        view.text = text
        view.color = NSColor(color)
    }
}

// Координатор для обработки событий NSTextView
class Coordinator: NSObject, NSTextViewDelegate {
    func textDidChange(_ notification: Notification) {
        // Не требуется для read-only
    }
}

// Кастомный NSView, содержащий NSScrollView и NSTextView
final class CustomTextView: NSView {
    weak var delegate: NSTextViewDelegate?
    
    var text: String {  // Свойство для текста
        didSet {
            textView.string = text
            applyAttributes()
            updateContentSize()
        }
    }
    
    var color: NSColor {  // Свойство для цвета текста
        didSet {
            applyAttributes()
        }
    }
    
    var selectedRanges: [NSValue] = [] {  // Свойство для выделения текста
        didSet {
            guard selectedRanges.count > 0 else { return }
            textView.selectedRanges = selectedRanges
        }
    }
    
    private var isEditable: Bool  // Флаг редактируемости
    private var font: NSFont?  // Шрифт для текста
    
    // Скроллвью для прокрутки содержимого
    private lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.drawsBackground = true
        scrollView.backgroundColor = .black  // Черный фон
        scrollView.borderType = .noBorder  // Без рамки
        scrollView.hasVerticalScroller = true  // Включаем вертикальную прокрутку
        scrollView.hasHorizontalScroller = true  // Включаем горизонтальную прокрутку
        scrollView.autohidesScrollers = true  // Автоскрытие скроллбаров
        scrollView.autoresizingMask = [.width, .height]  // Адаптация размеров
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // Текстовое поле для отображения ASCII-арта
    private lazy var textView: NSTextView = {
        let textStorage = NSTextStorage()
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(containerSize: CGSize(width: 0, height: CGFloat.greatestFiniteMagnitude))
        textContainer.widthTracksTextView = true  // Синхронизация ширины с текст вью
        layoutManager.addTextContainer(textContainer)
        let textView = NSTextView(frame: .zero, textContainer: textContainer)
        textView.minSize = CGSize(width: 0, height: 0)
        textView.maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.autoresizingMask = .width  // Адаптация ширины
        textView.delegate = delegate
        textView.isEditable = isEditable
        textView.font = font
        textView.backgroundColor = .black  // Черный фон
        textView.allowsUndo = false  // Отключаем undo
        textView.textContainer?.lineBreakMode = .byClipping  // Отключаем перенос строк
        textView.isVerticallyResizable = true  // Разрешаем вертикальную ресайзинг
        textView.isHorizontallyResizable = false  // Запрещаем горизонтальную ресайзинг для скролла
        return textView
    }()
    
    // Инициализатор кастомного вью
    init(text: String, color: NSColor, isEditable: Bool, font: NSFont?) {
        self.text = text
        self.color = color
        self.isEditable = isEditable
        self.font = font
        super.init(frame: .zero)
        addSubview(scrollView)
        scrollView.documentView = textView
        // Устанавливаем constraints для скроллвью
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        applyAttributes()
        updateContentSize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Применение атрибутов текста (цвет, шрифт)
    private func applyAttributes() {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: font ?? NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        textView.textStorage?.setAttributedString(attributedString)
        textView.needsDisplay = true  // Принудительное обновление отображения
        textView.needsLayout = true  // Принудительное обновление layout
        scrollView.needsDisplay = true  // Обновление скроллвью
    }
    
    // Обновление размера содержимого для появления скроллбаров и полного отображения арта
    private func updateContentSize() {
        textView.sizeToFit()  // Подгонка размера текста
        let contentWidth = max(scrollView.contentSize.width, textView.frame.width)
        let contentHeight = max(200, textView.frame.height)
        let contentSize = CGSize(width: contentWidth, height: contentHeight)
        textView.frame = CGRect(origin: .zero, size: contentSize)
        textView.textContainer?.containerSize = contentSize  // Обновляем containerSize
        scrollView.documentView?.frame = CGRect(origin: .zero, size: contentSize)  // Устанавливаем frame documentView
    }
}

struct TextToASCIIView: View {
    @StateObject private var viewModel = TextToASCIIViewModel()  // Модель для обработки текста
    @EnvironmentObject var alertManager: AlertManager  // Менеджер оповещений
    @EnvironmentObject var appSettings: AppSettings  // Настройки приложения
    let onBack: () -> Void  // Колбэк для возврата
    @State private var maxWidth: Int32 = 120  // Максимальная ширина ASCII-арта
    
    var body: some View {
        GeometryReader { geometry in  // Адаптация под размер окна
            ZStack {  // Фон и контент
                Color.black.ignoresSafeArea(.all)  // Черный фон на весь экран
                
                VStack(spacing: 20) {  // Вертикальный стек элементов
                    CustomText(text: "Конвертер текста в ASCII", size: 24, weight: .bold)  // Заголовок
                    
                    TextField("Введите текст (например, hello)", text: $viewModel.inputText)  // Поле ввода
                        .font(.system(size: 16, design: .monospaced))  // Моноширинный шрифт
                        .foregroundColor(appSettings.selectedColor.color)  // Цвет текста
                        .padding()  // Внутренние отступы
                        .frame(maxWidth: .infinity)  // Полная ширина
                        .background(appSettings.selectedColor.color.opacity(0.1))  // Фон
                        .cornerRadius(10)  // Закругленные углы
                        .overlay(RoundedRectangle(cornerRadius: 10)  // Обводка
                            .stroke(appSettings.selectedColor.color, lineWidth: 2))
                    
                    if !viewModel.asciiArt.isEmpty {  // Если арт сгенерирован
                        // Отладочный вывод для проверки текста
                        let _ = print("TextToASCIIView: ASCII art = \(viewModel.asciiArt.prefix(100))...")
                        
                        ASCIIArtTextView(text: viewModel.asciiArt, color: appSettings.selectedColor.color)  // Отображаем арт
                            .frame(maxWidth: geometry.size.width, maxHeight: .infinity)  // Ограничение размера
                            .border(appSettings.selectedColor.color.opacity(0.5), width: 1)  // Обводка
                        
                        CustomButton(title: "Скопировать ASCII-арт", action: {  // Кнопка копирования
                            viewModel.asciiArt.copyToClipboard()  // Копируем в буфер
                            DispatchQueue.main.async {  // Показываем алерт
                                alertManager.showAlert(title: "Успех", message: "ASCII-арт скопирован в буфер обмена")
                            }
                        }, maxWidth: .infinity, fontSize: 14)  // Единый стиль кнопки
                            .scaledToFit()  // Масштабируем
                            .minimumScaleFactor(0.5)  // Минимальный масштаб
                    } else {  // Плейсхолдер
                        CustomText(text: "Введите текст для создания ASCII-арта", size: 14)  // Текст подсказки
                            .opacity(0.6)  // Полупрозрачность
                            .frame(maxHeight: .infinity)  // Полная высота
                    }
                    
                    CustomButton(title: "Вернуться в меню", action: onBack, maxWidth: .infinity, fontSize: 14)  // Кнопка возврата
                        .scaledToFit()  // Масштабируем
                        .minimumScaleFactor(0.5)  // Минимальный масштаб
                }
                .padding()  // Отступы
                .frame(maxHeight: geometry.size.height)  // Ограничение высоты
                .padding(.bottom, 20)  // Отступ снизу
            }
            .onAppear {  // При загрузке
                maxWidth = Int32(max(80, Int(geometry.size.width / 12)))  // Устанавливаем ширину
                viewModel.convertTextToASCII(maxWidth: maxWidth)  // Начальная конвертация
            }
            .onChange(of: geometry.size) {  // При изменении размера окна
                maxWidth = Int32(max(80, Int($0.width / 12)))  // Пересчитываем ширину
                viewModel.convertTextToASCII(maxWidth: maxWidth)  // Перегенерируем арт
            }
        }
    }
}