//
//  PinNames.h
//  spiTest
//
//  Created by Kristoffer Andersen on 26/05/15.
//
//

#ifndef spiTest_PinNames_h
#define spiTest_PinNames_h


#ifdef __cplusplus
extern "C" {
#endif
    
#include <project.h>
    
#ifdef __cplusplus
}
#endif


typedef enum {
    PIN_INPUT,
    PIN_OUTPUT
} PinDirection;

typedef enum {
    HARD_WIRED,
    
    // Auxillary pins
    SW_USER = CYREG_PRT5_PC4,                   /**< User button pin, active low */
    BUZZER = CYREG_PRT5_PC3,                    /**< Buzzer PWM signal pin */
    EXPANSION_PWR_ENABLE = CYREG_PRT5_PC6,      /**< Enable the power for expansion connector (5V default)  */
    EXPANSIO_3V3_ENABLE = CYREG_PRT5_PC5,       /**< Enable 3.3V on HIGH , LOW is 5V. */
    
    //Redpine wireless pins
    RP_SPI_HARD_WIRE,                           /**< Enum for the wireless module SPI */
    RP_SPI_CLK = RP_SPI_HARD_WIRE,              
    RP_SPI_MOSI = RP_SPI_HARD_WIRE,
    RP_SPI_MISO = RP_SPI_HARD_WIRE,
    RP_SPI_CS = CYREG_PRT2_PC2,                 /**< Chip select for wireless module SPI, active low */
    RP_nRESET = CYREG_PRT5_PC0,                 /**< Reset line for wireless module, (open-drain) active low */
    RP_INTERRUPT = CYREG_PRT2_PC4,              /**< Wireless module interrupt on data, input! */
    
    //SD Card SPI pins
    SD_SPI_HARD_WIRE,                           /**< Enum for SD card SPI pins */
    SD_SPI_CLK = SD_SPI_HARD_WIRE,
    SD_SPI_MOSI = SD_SPI_HARD_WIRE,
    SD_SPI_MISO = SD_SPI_HARD_WIRE,
    SD_SPI_CS = CYREG_PRT6_PC3,                 /**< SD Card chip select */
    
    //Display SPI pins
    TFT_SPI_HARD_WIRE,
    TFT_SPI_CLK = TFT_SPI_HARD_WIRE,
    TFT_SPI_MOSI = TFT_SPI_HARD_WIRE,
    TFT_SPI_MISO = TFT_SPI_HARD_WIRE,
    TFT_SPI_CS = TFT_SPI_HARD_WIRE,
    
    //Display pins
    TFT_LED_PWR = CYREG_PRT5_PC1,
    TFT_REGISTER_SELECT = CYREG_PRT6_PC7,
    TFT_RESET = CYREG_PRT2_PC0,
    TFT_TEARING_EFFECT = CYREG_IO_PC_PRT15_PC5,
    TFT_IM0 = CYREG_PRT2_PC3,
    TFT_TOUCH_Y1 = CYREG_PRT1_PC7,
    TFT_TOUCH_X1 = CYREG_PRT1_PC6,
    TFT_TOUCH_Y2 = CYREG_PRT1_PC5,
    TFT_TOUCH_X2 = CYREG_PRT1_PC2,
    
    //Mini jack connector and arduino pins
    ARD_D9_JC_TIP    = CYREG_PRT12_PC3,
    ARD_D10_JC_RING1 = CYREG_PRT0_PC2,
    ARD_D11_JC_RING2 = CYREG_PRT0_PC1,
    JC_JPI_EN        = CYREG_PRT12_PC2,
    JC_JPO_EN        = CYREG_PRT12_PC4,
    JC_SL_CTRL       = CYREG_PRT0_PC0,
    
    // Arduino Digital pins
    ARD_D0 = CYREG_PRT4_PC0,
    ARD_D1 = CYREG_PRT4_PC1,
    ARD_D2 = CYREG_PRT4_PC2,
    ARD_D3 = CYREG_PRT4_PC3,
    ARD_D4 = CYREG_PRT4_PC4,
    ARD_D5 = CYREG_PRT4_PC5,
    ARD_D6 = CYREG_PRT4_PC6,
    ARD_D7 = CYREG_PRT4_PC7,
    
    ARD_D8 = CYREG_PRT0_PC3,
    
    ARD_D12 = CYREG_PRT0_PC5,
    ARD_D13 = CYREG_PRT0_PC6,
    
    // Arduino Analog pins
    ARD_A0 = CYREG_PRT3_PC2,
    ARD_A1 = CYREG_PRT3_PC1,
    ARD_A2 = CYREG_PRT3_PC0,
    ARD_A3 = CYREG_PRT3_PC3,
    ARD_A4 = CYREG_PRT3_PC4,
    ARD_A5 = CYREG_PRT3_PC5,
    
    USBTX,
    USBRX,
    
    NC = -1
} PinName;

typedef enum {
    PullUp = 0,
    PullDown = 3,
    PullNone = 2,
    PullBoth = 5,
    Repeater = 1,
    OpenDrain = 4,
    PullDefault = PullDown
} PinMode;

#endif
