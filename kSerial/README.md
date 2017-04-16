[MATLAB](https://github.com/Hom-Wang/MATLAB)
========

kSerial format  
byte[   1 :   2 ] - "KS"  
byte[   3 :   4 ] - TTTT LLLL LLLL LLLL, T : type (4 bits), L : data length (12 bits)  
byte[   5 : L+4 ] - data * L  
byte[ L+5 : L+6 ] - sequence number  
byte[ L+7 : L+8 ] - "\r\n"  
