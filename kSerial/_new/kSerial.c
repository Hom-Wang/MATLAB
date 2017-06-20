/**
  *      __            ____
  *     / /__ _  __   / __/                      __  
  *    / //_/(_)/ /_ / /  ___   ____ ___  __ __ / /_ 
  *   / ,<  / // __/_\ \ / _ \ / __// _ \/ // // __/ 
  *  /_/|_|/_/ \__//___// .__//_/   \___/\_,_/ \__/  
  *                    /_/   github.com/KitSprout    
  * 
  * @file    kSerial.c
  * @author  KitSprout
  * @date    20-Jun-2017
  * @brief   kSerial packet format :
  *          byte 1   : header 'K' (75)   [HK]
  *          byte 2   : header 'S' (83)   [HS]
  *          byte 3   : total length      [L ]
  *          byte 4   : command 1         [C1]
  *          byte 5   : command 2         [C2]
  *          byte 6   : data type         [T ]
  *           ...
  *          byte 6+L : data              [D ]
  *          byte 7+L : finish '\r' (13)  [ER]
  *          byte 8+L : finish '\n' (10)  [EN]
  */
/* Includes --------------------------------------------------------------------------------*/
#include "drivers\stm32f4_system.h"
#include "modules\kSerial.h"

/** @addtogroup STM32_Application
  * @{
  */

/* Private typedef -------------------------------------------------------------------------*/
/* Private define --------------------------------------------------------------------------*/
#define KS_MAX_SEND_BUFF_SIZE   256
#define KS_MAX_RECV_BUFF_SIZE   256

/* Private macro ---------------------------------------------------------------------------*/
/* Private variables -----------------------------------------------------------------------*/
static USART_TypeDef *kSerialUart = NULL;
static uint8_t ksSendBuffer[KS_MAX_SEND_BUFF_SIZE] = {0};
static uint8_t ksRecvBuffer[KS_MAX_RECV_BUFF_SIZE] = {0};

/* Private function prototypes -------------------------------------------------------------*/
/* Private functions -----------------------------------------------------------------------*/

/**
  * @brief  kSerial_Send
  */
static void kSerial_Send( uint8_t *sendData, uint16_t lens )
{
  do {
    kSerialUart->DR = (*sendData++ & (uint16_t)0x01FF);
    while (!(kSerialUart->SR & UART_FLAG_TXE));
  } while (--lens);
}

/**
  * @brief  kSerial_Recv
  */
static uint8_t kSerial_Recv( void )
{
  while (!(kSerialUart->SR & UART_FLAG_RXNE));
  return ((uint16_t)(kSerialUart->DR & (uint16_t)0x01FF));
}

/**
  * @brief  kSerial_Config
  */
void kSerial_Config( USART_TypeDef *USARTx )
{
  kSerialUart = USARTx;

  ksSendBuffer[0] = 'K';  /* header 'K'   */
  ksSendBuffer[1] = 'S';  /* header 'S'   */
  ksSendBuffer[2] = 8;    /* total length */
  ksSendBuffer[3] = 0;    /* command 1    */
  ksSendBuffer[4] = 0;    /* command 2    */
  ksSendBuffer[5] = 0;    /* data type    */
                      /* data ....... */
  ksSendBuffer[6] = '\r'; /* finish '\r'  */
  ksSendBuffer[7] = '\n'; /* finish '\n'  */
}

/**
  * @brief  kSerial_sendData
  */
int8_t kSerial_SendData( uint8_t *cmd, void *data, const uint8_t lens, const uint8_t type )
{
  const uint8_t packetDataLens = lens * (type & (uint8_t)0x0F);

  ksSendBuffer[0] = 'K';                        /* header 'K'   */
  ksSendBuffer[1] = 'S';                        /* header 'S'   */
  ksSendBuffer[2] = 8 + packetDataLens;         /* total length */
  if (cmd != NULL) {
    ksSendBuffer[3] = cmd[0];                   /* command 1    */
    ksSendBuffer[4] = cmd[1];                   /* command 2    */
  }
  else {
    ksSendBuffer[3] = 0;
    ksSendBuffer[4] = 0;
  }
  ksSendBuffer[5] = type;                       /* data type    */


  for (uint8_t i = 0; i < packetDataLens; i++) {
    ksSendBuffer[6 + i] = ((uint8_t*)data)[i];  /* data ....... */
  }

  ksSendBuffer[6 + packetDataLens] = '\r';      /* finish '\r'  */
  ksSendBuffer[7 + packetDataLens] = '\n';      /* finish '\n'  */

  kSerial_Send(ksSendBuffer, 8 + packetDataLens);

  return HAL_OK;
}

/**
  * @brief  kSerial_RecvData
  */
int8_t kSerial_RecvData( uint8_t *lens, uint8_t *type, uint8_t *cmd, uint8_t *data )
{
  static uint8_t point = 0;
  static uint8_t index = 0;
  static uint8_t bytes = 0;

  ksRecvBuffer[point] = kSerial_Recv();

  if (point > 1) {
    if ((ksRecvBuffer[point - 2] == 'K') && (ksRecvBuffer[point - 1] == 'S')) {
      index = point - 2;
      bytes = ksRecvBuffer[point];
    }
    if ((point - index + 1) == bytes) {
      if ((ksRecvBuffer[index] == 'K') && (ksRecvBuffer[index + 1] == 'S')) {
        *lens = ksRecvBuffer[index + 2];
        if ((ksRecvBuffer[index + *lens - 2] == '\r') && (ksRecvBuffer[index + *lens - 1] == '\n')) {
          cmd[0] = ksRecvBuffer[index + 3];
          cmd[1] = ksRecvBuffer[index + 4];
          *type  = ksRecvBuffer[index + 5];
          for (uint8_t i = 0; i < (*lens - 8); i++ ) {
            data[i] = ksRecvBuffer[index + 6 + i];
          }
          point = 0;
          index = 0;
          bytes = 0;
          return HAL_OK;
        }
      }
    }
  }
  point++;

  return HAL_ERROR;
}

/*************************************** END OF FILE ****************************************/
