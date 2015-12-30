/*******************************************************************************
* File Name: TFT_IM0.h  
* Version 2.10
*
* Description:
*  This file containts Control Register function prototypes and register defines
*
* Note:
*
********************************************************************************
* Copyright 2008-2014, Cypress Semiconductor Corporation.  All rights reserved.
* You may use this file only in accordance with the license, terms, conditions, 
* disclaimers, and limitations in the end user license agreement accompanying 
* the software package with which this file was provided.
*******************************************************************************/

#if !defined(CY_PINS_TFT_IM0_H) /* Pins TFT_IM0_H */
#define CY_PINS_TFT_IM0_H

#include "cytypes.h"
#include "cyfitter.h"
#include "cypins.h"
#include "TFT_IM0_aliases.h"

/* Check to see if required defines such as CY_PSOC5A are available */
/* They are defined starting with cy_boot v3.0 */
#if !defined (CY_PSOC5A)
    #error Component cy_pins_v2_10 requires cy_boot v3.0 or later
#endif /* (CY_PSOC5A) */

/* APIs are not generated for P15[7:6] */
#if !(CY_PSOC5A &&\
	 TFT_IM0__PORT == 15 && ((TFT_IM0__MASK & 0xC0) != 0))


/***************************************
*        Function Prototypes             
***************************************/    

void    TFT_IM0_Write(uint8 value) ;
void    TFT_IM0_SetDriveMode(uint8 mode) ;
uint8   TFT_IM0_ReadDataReg(void) ;
uint8   TFT_IM0_Read(void) ;
uint8   TFT_IM0_ClearInterrupt(void) ;


/***************************************
*           API Constants        
***************************************/

/* Drive Modes */
#define TFT_IM0_DM_ALG_HIZ         PIN_DM_ALG_HIZ
#define TFT_IM0_DM_DIG_HIZ         PIN_DM_DIG_HIZ
#define TFT_IM0_DM_RES_UP          PIN_DM_RES_UP
#define TFT_IM0_DM_RES_DWN         PIN_DM_RES_DWN
#define TFT_IM0_DM_OD_LO           PIN_DM_OD_LO
#define TFT_IM0_DM_OD_HI           PIN_DM_OD_HI
#define TFT_IM0_DM_STRONG          PIN_DM_STRONG
#define TFT_IM0_DM_RES_UPDWN       PIN_DM_RES_UPDWN

/* Digital Port Constants */
#define TFT_IM0_MASK               TFT_IM0__MASK
#define TFT_IM0_SHIFT              TFT_IM0__SHIFT
#define TFT_IM0_WIDTH              1u


/***************************************
*             Registers        
***************************************/

/* Main Port Registers */
/* Pin State */
#define TFT_IM0_PS                     (* (reg8 *) TFT_IM0__PS)
/* Data Register */
#define TFT_IM0_DR                     (* (reg8 *) TFT_IM0__DR)
/* Port Number */
#define TFT_IM0_PRT_NUM                (* (reg8 *) TFT_IM0__PRT) 
/* Connect to Analog Globals */                                                  
#define TFT_IM0_AG                     (* (reg8 *) TFT_IM0__AG)                       
/* Analog MUX bux enable */
#define TFT_IM0_AMUX                   (* (reg8 *) TFT_IM0__AMUX) 
/* Bidirectional Enable */                                                        
#define TFT_IM0_BIE                    (* (reg8 *) TFT_IM0__BIE)
/* Bit-mask for Aliased Register Access */
#define TFT_IM0_BIT_MASK               (* (reg8 *) TFT_IM0__BIT_MASK)
/* Bypass Enable */
#define TFT_IM0_BYP                    (* (reg8 *) TFT_IM0__BYP)
/* Port wide control signals */                                                   
#define TFT_IM0_CTL                    (* (reg8 *) TFT_IM0__CTL)
/* Drive Modes */
#define TFT_IM0_DM0                    (* (reg8 *) TFT_IM0__DM0) 
#define TFT_IM0_DM1                    (* (reg8 *) TFT_IM0__DM1)
#define TFT_IM0_DM2                    (* (reg8 *) TFT_IM0__DM2) 
/* Input Buffer Disable Override */
#define TFT_IM0_INP_DIS                (* (reg8 *) TFT_IM0__INP_DIS)
/* LCD Common or Segment Drive */
#define TFT_IM0_LCD_COM_SEG            (* (reg8 *) TFT_IM0__LCD_COM_SEG)
/* Enable Segment LCD */
#define TFT_IM0_LCD_EN                 (* (reg8 *) TFT_IM0__LCD_EN)
/* Slew Rate Control */
#define TFT_IM0_SLW                    (* (reg8 *) TFT_IM0__SLW)

/* DSI Port Registers */
/* Global DSI Select Register */
#define TFT_IM0_PRTDSI__CAPS_SEL       (* (reg8 *) TFT_IM0__PRTDSI__CAPS_SEL) 
/* Double Sync Enable */
#define TFT_IM0_PRTDSI__DBL_SYNC_IN    (* (reg8 *) TFT_IM0__PRTDSI__DBL_SYNC_IN) 
/* Output Enable Select Drive Strength */
#define TFT_IM0_PRTDSI__OE_SEL0        (* (reg8 *) TFT_IM0__PRTDSI__OE_SEL0) 
#define TFT_IM0_PRTDSI__OE_SEL1        (* (reg8 *) TFT_IM0__PRTDSI__OE_SEL1) 
/* Port Pin Output Select Registers */
#define TFT_IM0_PRTDSI__OUT_SEL0       (* (reg8 *) TFT_IM0__PRTDSI__OUT_SEL0) 
#define TFT_IM0_PRTDSI__OUT_SEL1       (* (reg8 *) TFT_IM0__PRTDSI__OUT_SEL1) 
/* Sync Output Enable Registers */
#define TFT_IM0_PRTDSI__SYNC_OUT       (* (reg8 *) TFT_IM0__PRTDSI__SYNC_OUT) 


#if defined(TFT_IM0__INTSTAT)  /* Interrupt Registers */

    #define TFT_IM0_INTSTAT                (* (reg8 *) TFT_IM0__INTSTAT)
    #define TFT_IM0_SNAP                   (* (reg8 *) TFT_IM0__SNAP)

#endif /* Interrupt Registers */

#endif /* CY_PSOC5A... */

#endif /*  CY_PINS_TFT_IM0_H */


/* [] END OF FILE */
