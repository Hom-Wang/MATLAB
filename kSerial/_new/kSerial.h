/**
  *      __            ____
  *     / /__ _  __   / __/                      __  
  *    / //_/(_)/ /_ / /  ___   ____ ___  __ __ / /_ 
  *   / ,<  / // __/_\ \ / _ \ / __// _ \/ // // __/ 
  *  /_/|_|/_/ \__//___// .__//_/   \___/\_,_/ \__/  
  *                    /_/   github.com/KitSprout    
  * 
  * @file    kSerial.h
  * @author  KitSprout
  * @date    20-Jun-2017
  * @brief   
  * 
  */

/* Define to prevent recursive inclusion ---------------------------------------------------*/
#ifndef __KSERIAL_H
#define __KSERIAL_H

#ifdef __cplusplus
 extern "C" {
#endif

/* Includes --------------------------------------------------------------------------------*/
#include "stm32f4xx.h"
#include "algorithms\mathUnit.h"

/* Exported types --------------------------------------------------------------------------*/
typedef enum {
  KS_NTYPE = 0x00,  /* 8'b 0000 0000 */
  KS_I8    = 0x11,  /* 8'b 0001 0001 */
  KS_I16   = 0x12,  /* 8'b 0001 0010 */
  KS_I32   = 0x14,  /* 8'b 0001 0100 */
  KS_I64   = 0x18,  /* 8'b 0001 1000 */
  KS_U8    = 0x21,  /* 8'b 0010 0001 */
  KS_U16   = 0x22,  /* 8'b 0010 0010 */
  KS_U32   = 0x24,  /* 8'b 0010 0100 */
  KS_U64   = 0x28,  /* 8'b 0010 1000 */
  KS_F32   = 0x44,  /* 8'b 0100 0100 */
  KS_F64   = 0x48,  /* 8'b 0100 1000 */
} KSerial_Typedef;

/* Exported constants ----------------------------------------------------------------------*/
/* Exported functions ----------------------------------------------------------------------*/  
void 	  kSerial_Config( USART_TypeDef *USARTx );
int8_t 	kSerial_SendData( uint8_t *cmd, void *data, const uint8_t lens, const uint8_t type );
int8_t  kSerial_RecvData( uint8_t *lens, uint8_t *type, uint8_t *cmd, uint8_t *data );

#ifdef __cplusplus
}
#endif

#endif

/*************************************** END OF FILE ****************************************/
