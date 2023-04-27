// ############################################################################
// ############################################################################
// Code

// ############################################################################
// ############################################################################
// Include files

#include "board.h"

#include <stdio.h>
#include <stdio.h>

// ############################################################################
// ############################################################################
// Function definitions


/**
 * \brief Get the boards name.
 *
 * \return The board's name.
 */
const char *getBoardName( void )
{
	return "GNU/Linux PC";
}


/**
 * \brief Initialise the led.
 */
void bsp_setup_led( void )
{
	( void )printf( "Led: setup\n" );
}


/**
 * \brief Turn the led on.
 */
void bsp_led_on( void )
{
	( void )printf( "Led: ON\n" );
}


/**
 * \brief Turn the led off.
 */
void bsp_led_off( void )
{
	( void )printf( "Led: OFF\n" );
}


/**
 * \brief Delay for some time.
 */
void bsp_delay( const uint32_t num )
{
	( void )num;
#if 0
	( void )printf( "Delay...\n" );
#endif
}
