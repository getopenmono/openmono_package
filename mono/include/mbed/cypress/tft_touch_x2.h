/*******************************************************************************
* File Name: tft_touch_x2.h  
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

#if !defined(CY_PINS_tft_touch_x2_H) /* Pins tft_touch_x2_H */
#define CY_PINS_tft_touch_x2_H

#include "cytypes.h"
#include "cyfitter.h"
#include "cypins.h"
#include "tft_touch_x2_aliases.h"

/* Check to see if required defines such as CY_PSOC5A are available */
/* They are defined starting with cy_boot v3.0 */
#if !defined (CY_PSOC5A)
    #error Component cy_pins_v2_10 requires cy_boot v3.0 or later
#endif /* (CY_PSOC5A) */

/* APIs are not generated for P15[7:6] */
#if !(CY_PSOC5A &&\
	 tft_touch_x2__PORT == 15 && ((tft_touch_x2__MASK & 0xC0) != 0))


/***************************************
*        Function Prototypes             
***************************************/    

void    tft_touch_x2_Write(uint8 value) ;
void    tft_touch_x2_SetDriveMode(uint8 mode) ;
uint8   tft_touch_x2_ReadDataReg(void) ;
uint8   tft_touch_x2_Read(void) ;
uint8   tft_touch_x2_ClearInterrupt(void) ;


/***************************************
*           API Constants        
***************************************/

/* Drive Modes */
#define tft_touch_x2_DM_ALG_HIZ         PIN_DM_ALG_HIZ
#define tft_touch_x2_DM_DIG_HIZ         PIN_DM_DIG_HIZ
#define tft_touch_x2_DM_RES_UP          PIN_DM_RES_UP
#define tft_touch_x2_DM_RES_DWN         PIN_DM_RES_DWN
#define tft_touch_x2_DM_OD_LO           PIN_DM_OD_LO
#define tft_touch_x2_DM_OD_HI           PIN_DM_OD_HI
#define tft_touch_x2_DM_STRONG          PIN_DM_STRONG
#define tft_touch_x2_DM_RES_UPDWN       PIN_DM_RES_UPDWN

/* Digital Port Constants */
#define tft_touch_x2_MASK               tft_touch_x2__MASK
#define tft_touch_x2_SHIFT              tft_touch_x2__SHIFT
#define tft_touch_x2_WIDTH              1u


/***************************************
*             Registers        
***************************************/

/* Main Port Registers */
/* Pin State */
#define tft_touch_x2_PS                     (* (reg8 *) tft_touch_x2__PS)
/* Data Register */
#define tft_touch_x2_DR                     (* (reg8 *) tft_touch_x2__DR)
/* Port Number */
#define tft_touch_x2_PRT_NUM                (* (reg8 *) tft_touch_x2__PRT) 
/* Connect to Analog Globals */                                                  
#define tft_touch_x2_AG                     (* (reg8 *) tft_touch_x2__AG)                       
/* Analog MUX bux enable */
#define tft_touch_x2_AMUX                   (* (reg8 *) tft_touch_x2__AMUX) 
/* Bidirectional Enable */                                                        
#define tft_touch_x2_BIE                    (* (reg8 *) tft_touch_x2__BIE)
/* Bit-mask for Aliased Register Access */
#define tft_touch_x2_BIT_MASK               (* (reg8 *) tft_touch_x2__BIT_MASK)
/* Bypass Enable */
#define tft_touch_x2_BYP                    (* (reg8 *) tft_touch_x2__BYP)
/* Port wide control signals */                                                   
#define tft_touch_x2_CTL                    (* (reg8 *) tft_touch_x2__CTL)
/* Drive Modes */
#define tft_touch_x2_DM0                    (* (reg8 *) tft_touch_x2__DM0) 
#define tft_touch_x2_DM1                    (* (reg8 *) tft_touch_x2__DM1)
#define tft_touch_x2_DM2                    (* (reg8 *) tft_touch_x2__DM2) 
/* Input Buffer Disable Override */
#define tft_touch_x2_INP_DIS                (* (reg8 *) tft_touch_x2__INP_DIS)
/* LCD Common or Segment Drive */
#define tft_touch_x2_LCD_COM_SEG            (* (reg8 *) tft_touch_x2__LCD_COM_SEG)
/* Enable Segment LCD */
#define tft_touch_x2_LCD_EN                 (* (reg8 *) tft_touch_x2__LCD_EN)
/* Slew Rate Control */
#define tft_touch_x2_SLW                    (* (reg8 *) tft_touch_x2__SLW)

/* DSI Port Registers */
/* Global DSI Select Register */
#define tft_touch_x2_PRTDSI__CAPS_SEL       (* (reg8 *) tft_touch_x2__PRTDSI__CAPS_SEL) 
/* Double Sync Enable */
#define tft_touch_x2_PRTDSI__DBL_SYNC_IN    (* (reg8 *) tft_touch_x2__PRTDSI__DBL_SYNC_IN) 
/* Output Enable Select Drive Strength */
#define tft_touch_x2_PRTDSI__OE_SEL0        (* (reg8 *) tft_touch_x2__PRTDSI__OE_SEL0) 
#define tft_touch_x2_PRTDSI__OE_SEL1        (* (reg8 *) tft_touch_x2__PRTDSI__OE_SEL1) 
/* Port Pin Output Select Registers */
#define tft_touch_x2_PRTDSI__OUT_SEL0       (* (reg8 *) tft_touch_x2__PRTDSI__OUT_SEL0) 
#define tft_touch_x2_PRTDSI__OUT_SEL1       (* (reg8 *) tft_touch_x2__PRTDSI__OUT_SEL1) 
/* Sync Output Enable Registers */
#define tft_touch_x2_PRTDSI__SYNC_OUT       (* (reg8 *) tft_touch_x2__PRTDSI__SYNC_OUT) 


#if defined(tft_touch_x2__INTSTAT)  /* Interrupt Registers */

    #define tft_touch_x2_INTSTAT                (* (reg8 *) tft_touch_x2__INTSTAT)
    #define tft_touch_x2_SNAP                   (* (reg8 *) tft_touch_x2__SNAP)

#endif /* Interrupt Registers */

#endif /* CY_PSOC5A... */

#endif /*  CY_PINS_tft_touch_x2_H */


/* [] END OF FILE */
