/******************************************************************************
	Code
******************************************************************************/

/******************************************************************************
	Include files
******************************************************************************/

#include "board.h"

#include "TM4C123.h"

#include <stdint.h>


/******************************************************************************
	Definitions
******************************************************************************/

//#define LED_RED   (1U << 1)
//#define LED_BLUE  (1U << 2)
#define LED_GREEN (1U << 3)


/******************************************************************************
	Function definitions
******************************************************************************/

/**
 * \brief Get the boards name.
 *
 * \return		The board's name.
 */
const char *getBoardName( void )
{
	return "TM4C123GXL";
}

void bsp_setup_led( void )
{
	SYSCTL->RCGCGPIO  |= ( 1U << 5 ); /* enable Run mode for GPIOF */
	SYSCTL->GPIOHBCTL |= ( 1U << 5 ); /* enable AHB for GPIOF */
	GPIOF_AHB->DIR |= ( LED_GREEN );
	GPIOF_AHB->DEN |= ( LED_GREEN );
}

void bsp_led_on( void )
{
	GPIOF_AHB->DATA_Bits[LED_GREEN] = LED_GREEN;
}

void bsp_led_off( void )
{
	GPIOF_AHB->DATA_Bits[LED_GREEN] = 0U;
}

void bsp_delay( const uint32_t num )
{
	for( uint32_t i = 20U; i > 0; i-- )
	{
		for( uint32_t i = num; i > 0; i-- )
		{
			__NOP();
		}
	}
}
