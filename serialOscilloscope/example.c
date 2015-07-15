
void Serial_sendDataMATLAB( int16_t *sendData, uint8_t dataLens )
{
  uint8_t tmpData[16] = {0};
  uint8_t *ptrData = tmpData;
  uint8_t dataBytes = dataLens - 4;
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
    Bluetooth_SendByte(*ptrData++);
  } while(--dataLens);
}

int main( void )
{
  int16_t IMU_Buf[8] = {0};

  while(1) {
    MPU9255_getData(IMU_Buf);
    Serial_sendDataMATLAB(IMU_Buf, 16);
    Delay_1ms(5);
  }
}
