/*******************************************************************************
* File Name: ACC_INT2.h  
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

#if !defined(CY_PINS_ACC_INT2_H) /* Pins ACC_INT2_H */
#define CY_PINS_ACC_INT2_H

#include "cytypes.h"
#include "cyfitter.h"
#include "cypins.h"
#include "ACC_INT2_aliases.h"

/* Check to see if required defines such as CY_PSOC5A are available */
/* They are defined starting with cy_boot v3.0 */
#if !defined (CY_PSOC5A)
    #error Component cy_pins_v2_10 requires cy_boot v3.0 or later
#endif /* (CY_PSOC5A) */

/* APIs are not generated for P15[7:6] */
#if !(CY_PSOC5A &&\
	 ACC_INT2__PORT == 15 && ((ACC_INT2__MASK & 0xC0) != 0))


/***************************************
*        Function Prototypes             
***************************************/    

void    ACC_INT2_Write(uint8 value) ;
void    ACC_INT2_SetDriveMode(uint8 mode) ;
uint8   ACC_INT2_ReadDataReg(void) ;
uint8   ACC_INT2_Read(void) ;
uint8   ACC_INT2_ClearInterrupt(void) ;


/***************************************
*           API Constants        
***************************************/

/* Drive Modes */
#define ACC_INT2_DM_ALG_HIZ         PIN_DM_ALG_HIZ
#define ACC_INT2_DM_DIG_HIZ         PIN_DM_DIG_HIZ
#define ACC_INT2_DM_RES_UP          PIN_DM_RES_UP
#define ACC_INT2_DM_RES_DWN         PIN_DM_RES_DWN
#define ACC_INT2_DM_OD_LO           PIN_DM_OD_LO
#define ACC_INT2_DM_OD_HI           PIN_DM_OD_HI
#define ACC_INT2_DM_STRONG          PIN_DM_STRONG
#define ACC_INT2_DM_RES_UPDWN       PIN_DM_RES_UPDWN

/* Digital Port Constants */
#define ACC_INT2_MASK               ACC_INT2__MASK
#define ACC_INT2_SHIFT              ACC_INT2__SHIFT
#define ACC_INT2_WIDTH              1u


/***************************************
*             Registers        
***************************************/

/* Main Port Registers */
/* Pin State */
#define ACC_INT2_PS                     (* (reg8 *) ACC_INT2__PS)
/* Data Register */
#define ACC_INT2_DR                     (* (reg8 *) ACC_INT2__DR)
/* Port Number */
#define ACC_INT2_PRT_NUM                (* (reg8 *) ACC_INT2__PRT) 
/* Connect to Analog Globals */                                                  
#define ACC_INT2_AG                     (* (reg8 *) ACC_INT2__AG)                       
/* Analog MUX bux enable */
#define ACC_INT2_AMUX                   (* (reg8 *) ACC_INT2__AMUX) 
/* Bidirectional Enable */                                                        
#define ACC_INT2_BIE                    (* (reg8 *) ACC_INT2__BIE)
/* Bit-mask for Aliased Register Access */
#define ACC_INT2_BIT_MASK               (* (reg8 *) ACC_INT2__BIT_MASK)
/* Bypass Enable */
#define ACC_INT2_BYP                    (* (reg8 *) ACC_INT2__BYP)
/* Port wide control signals */                                                   
#define ACC_INT2_CTL                    (* (reg8 *) ACC_INT2__CTL)
/* Drive Modes */
#define ACC_INT2_DM0                    (* (reg8 *) ACC_INT2__DM0) 
#define ACC_INT2_DM1                    (* (reg8 *) ACC_INT2__DM1)
#define ACC_INT2_DM2                    (* (reg8 *) ACC_INT2__DM2) 
/* Input Buffer Disable Override */
#define ACC_INT2_INP_DIS                (* (reg8 *) ACC_INT2__INP_DIS)
/* LCD Common or Segment Drive */
#define ACC_INT2_LCD_COM_SEG            (* (reg8 *) ACC_INT2__LCD_COM_SEG)
/* Enable Segment LCD */
#define ACC_INT2_LCD_EN                 (* (reg8 *) ACC_INT2__LCD_EN)
/* Slew Rate Control */
#define ACC_INT2_SLW                    (* (reg8 *) ACC_INT2__SLW)

/* DSI Port Registers */
/* Global DSI Select Register */
#define ACC_INT2_PRTDSI__CAPS_SEL       (* (reg8 *) ACC_INT2__PRTDSI__CAPS_SEL) 
/* Double Sync Enable */
#define ACC_INT2_PRTDSI__DBL_SYNC_IN    (* (reg8 *) ACC_INT2__PRTDSI__DBL_SYNC_IN) 
/* Output Enable Select Drive Strength */
#define ACC_INT2_PRTDSI__OE_SEL0        (* (reg8 *) ACC_INT2__PRTDSI__OE_SEL0) 
#define ACC_INT2_PRTDSI__OE_SEL1        (* (reg8 *) ACC_INT2__PRTDSI__OE_SEL1) 
/* Port Pin Output Select Registers */
#define ACC_INT2_PRTDSI__OUT_SEL0       (* (reg8 *) ACC_INT2__PRTDSI__OUT_SEL0) 
#define ACC_INT2_PRTDSI__OUT_SEL1       (* (reg8 *) ACC_INT2__PRTDSI__OUT_SEL1) 
/* Sync Output Enable Registers */
#define ACC_INT2_PRTDSI__SYNC_OUT       (* (reg8 *) ACC_INT2__PRTDSI__SYNC_OUT) 


#if defined(ACC_INT2__INTSTAT)  /* Interrupt Registers */

    #define ACC_INT2_INTSTAT                (* (reg8 *) ACC_INT2__INTSTAT)
    #define ACC_INT2_SNAP                   (* (reg8 *) ACC_INT2__SNAP)

#endif /* Interrupt Registers */

#endif /* CY_PSOC5A... */

#endif /*  CY_PINS_ACC_INT2_H */


/* [] END OF FILE */
