[MATLAB](https://github.com/Hom-Wang/MATLAB)
========

serialPacket  

serial format  
byte[01:02] - "KS"  
byte[03:04] - sequence number  
byte[05:20] - float32 data * lens  
byte[21:22] - "\r\n"  
