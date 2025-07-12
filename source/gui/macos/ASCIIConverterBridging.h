//     #           "      m                   mmmm   mmmm   mmmm  mmmmmm
//  mmm#  mmmmm  mmm    mm#mm   m mm  m   m  "   "# m"  "m #    #     #"
// #" "#  # # #    #      #     #"  " "m m"      m" #  m # "mmmm"    m" 
// #   #  # # #    #      #     #      #m#     m"   #    # #   "#   m"  
// "#m##  # # #  mm#mm    "mm   #      "#    m#mmmm  #mm#  "#mmm"  m"   
//                                     m"                               
// Приложение ASCII-ART
// ASCIIConverterBridging.h

#ifndef ASCII_CONVERTER_BRIDGING_H
#define ASCII_CONVERTER_BRIDGING_H

#ifdef __cplusplus
extern "C" {
#endif

// C-совместимые функции для вызова из Swift
const char* convert_image_to_ascii(const char* imagePath, int outputWidth);
const char* convert_text_to_ascii(const char* text);
void free_ascii_string(const char* str);

#ifdef __cplusplus
}
#endif

#endif // ASCII_CONVERTER_BRIDGING_H