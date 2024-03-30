// ############################################################################
// ############################################################################
// Code

// ############################################################################
// ############################################################################
// Include files

#include "bsp.h"

#include "stm32f0xx.h"
#include <stdint.h>

// ############################################################################
// ############################################################################
// Function definitions

/**
 * \brief Initialise the board.
 */
void bsp_init( void )
{
	/* Pin is A5 */

	/* Enable GPIOA clock */
	SET_BIT( RCC->AHBENR, RCC_AHBENR_GPIOAEN );

	/* Set pin as output */
	SET_BIT( GPIOA->MODER, GPIO_MODER_MODER5_0 );
	CLEAR_BIT( GPIOA->MODER, GPIO_MODER_MODER5_1 );

	/* Set pin as push-pull */
	CLEAR_BIT( GPIOA->OTYPER, GPIO_OTYPER_OT_5 );

	/* Set pin speed high */
	SET_BIT( GPIOA->OSPEEDR, GPIO_OSPEEDR_OSPEEDR5_0 );
	SET_BIT( GPIOA->OSPEEDR, GPIO_OSPEEDR_OSPEEDR5_1 );

	/* Set pin pull resistor */
	SET_BIT( GPIOA->PUPDR, GPIO_PUPDR_PUPDR5_0 );
	CLEAR_BIT( GPIOA->PUPDR, GPIO_PUPDR_PUPDR5_1 );
}

/**
 * \brief Turn the led on.
 */
void bsp_led_on( void )
{
	/* Pin is A5 */

	/* Set bit high */
	SET_BIT( GPIOA->BSRR, GPIO_BSRR_BS_5 );
}


/**
 * \brief Turn the led off.
 */
void bsp_led_off( void )
{
	/* Pin is A5 */

	/* Set bit high */
	SET_BIT( GPIOA->BSRR, GPIO_BSRR_BR_5 );
}


/**
 * \brief Delay for some time.
 */
void bsp_delay( const uint32_t num )
{
	for( uint32_t i = num; i > 0UL; i-- )
	{
		__NOP();
	}
}

/**
 * \brief Get the boards name.
 *
 * \return The board's name.
 */
const char *bsp_getName( void )
{
	const char *boardName = "stm32f072rb";
	return boardName;
}
