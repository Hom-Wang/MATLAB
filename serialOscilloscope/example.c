/*====================================================================================================*/
/*====================================================================================================*
**函數 : Serial_SendDataMATLAB
**功能 : Send Data to MATLAB 
**輸入 : *sendData, lens
**輸出 : None
**使用 : Serial_SendDataMATLAB(sendData, 10); // int16 * 10 data
**====================================================================================================*/
/*====================================================================================================*/
void Serial_SendDataMATLAB( int16_t *sendData, uint8_t lens )
{
  uint8_t tmpData[32] = {0};  // tmpData lens >= 2 * lens + 4
  uint8_t *ptrData = tmpData;
  uint8_t dataBytes = lens << 1;
  uint8_t dataLens = dataBytes + 4;
  uint8_t count = 0;
  uint16_t tmpSum = 0;

  tmpData[0] = 'S';
  while(count < dataBytes) {
    tmpData[count+1] = Byte8H(sendData[count >> 1]);
    tmpData[count+2] = Byte8L(sendData[count >> 1]);
    count = count + 2;
  }
  for(uint8_t i = 0; i < dataBytes; i++)
    tmpSum += tmpData[i+1];
  tmpData[dataLens - 3] = (uint8_t)(tmpSum & 0x00FF);
  tmpData[dataLens - 2] = '\r';
  tmpData[dataLens - 1] = '\n';

  do {
    Serial_SendByte(*ptrData++);
  } while(--dataLens);
}
/*====================================================================================================*/
/*====================================================================================================*/
int main( void )
{
  int16_t testLostRate = 0;
  int16_t IMU_Buf[10] = {0};

  while(1) {
    MPU9250_getData(IMU_Buf);
	IMU_Buf[0] = testLostRate++;
    Serial_sendDataMATLAB(IMU_Buf, 10);
    Delay_1ms(4);
  }
}
/*====================================================================================================*/
/*====================================================================================================*/
