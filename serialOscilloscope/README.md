[MATLAB](https://github.com/Hom-Wang/MATLAB)
========

serialOscilloscope  

package format  
packageLens = int16Lens * 2 + 4  
  
byte[0] = 'S'  
byte[1] = data_01_H8  
byte[2] = data_01_L8  
byte[3] = data_02_H8  
byte[4] = data_02_L8  
byte[5] = data_03_H8  
byte[6] = data_03_L8  
...  
byte[packageLens - 5] = data_n_H8  
byte[packageLens - 4] = data_n_L8  
byte[packageLens - 3] = check sum  
byte[packageLens - 2] = '\r'  
byte[packageLens - 1] = '\n'  
  
<img src="https://lh3.googleusercontent.com/-vXIrr0oy8ZU/VaPwrzqVvpI/AAAAAAAANBM/4xX3xmOaUUk/s800-Ic42/serial%252520data%252520-%252520acc.gif"/>
  