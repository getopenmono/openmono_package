/*******************************************************************************
* File Name: PWR_INT.h
* Version 1.70
*
*  Description:
*   Provides the function definitions for the Interrupt Controller.
*
*
********************************************************************************
* Copyright 2008-2015, Cypress Semiconductor Corporation.  All rights reserved.
* You may use this file only in accordance with the license, terms, conditions, 
* disclaimers, and limitations in the end user license agreement accompanying 
* the software package with which this file was provided.
*******************************************************************************/
#if !defined(CY_ISR_PWR_INT_H)
#define CY_ISR_PWR_INT_H


#include <cytypes.h>
#include <cyfitter.h>

/* Interrupt Controller API. */
void PWR_INT_Start(void);
void PWR_INT_StartEx(cyisraddress address);
void PWR_INT_Stop(void);

CY_ISR_PROTO(PWR_INT_Interrupt);

void PWR_INT_SetVector(cyisraddress address);
cyisraddress PWR_INT_GetVector(void);

void PWR_INT_SetPriority(uint8 priority);
uint8 PWR_INT_GetPriority(void);

void PWR_INT_Enable(void);
uint8 PWR_INT_GetState(void);
void PWR_INT_Disable(void);

void PWR_INT_SetPending(void);
void PWR_INT_ClearPending(void);


/* Interrupt Controller Constants */

/* Address of the INTC.VECT[x] register that contains the Address of the PWR_INT ISR. */
#define PWR_INT_INTC_VECTOR            ((reg32 *) PWR_INT__INTC_VECT)

/* Address of the PWR_INT ISR priority. */
#define PWR_INT_INTC_PRIOR             ((reg8 *) PWR_INT__INTC_PRIOR_REG)

/* Priority of the PWR_INT interrupt. */
#define PWR_INT_INTC_PRIOR_NUMBER      PWR_INT__INTC_PRIOR_NUM

/* Address of the INTC.SET_EN[x] byte to bit enable PWR_INT interrupt. */
#define PWR_INT_INTC_SET_EN            ((reg32 *) PWR_INT__INTC_SET_EN_REG)

/* Address of the INTC.CLR_EN[x] register to bit clear the PWR_INT interrupt. */
#define PWR_INT_INTC_CLR_EN            ((reg32 *) PWR_INT__INTC_CLR_EN_REG)

/* Address of the INTC.SET_PD[x] register to set the PWR_INT interrupt state to pending. */
#define PWR_INT_INTC_SET_PD            ((reg32 *) PWR_INT__INTC_SET_PD_REG)

/* Address of the INTC.CLR_PD[x] register to clear the PWR_INT interrupt. */
#define PWR_INT_INTC_CLR_PD            ((reg32 *) PWR_INT__INTC_CLR_PD_REG)


#endif /* CY_ISR_PWR_INT_H */


/* [] END OF FILE */
